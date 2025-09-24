import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart'; // <-- for debugPrint
import 'package:true_sight/core/utils/status/api_status.dart';
import 'package:true_sight/features/detection/domain/entities/detection_result_entity.dart';
import 'package:true_sight/features/detection/domain/usecases/get_detection_result.dart';
import 'package:true_sight/features/detection/domain/usecases/get_detection_result_history.dart';

part 'detection_event.dart';
part 'detection_state.dart';

class DetectionBloc extends Bloc<DetectionEvent, DetectionState> {
  final GetDetectionResult _getDetectionResult;
  final GetDetectionResultHistory _getDetectionResultHistory;
  CancelToken? _cancelToken;

  DetectionBloc({
    required GetDetectionResult getDetectionResult,
    required GetDetectionResultHistory getDetectionResultHistory,
  }) : _getDetectionResult = getDetectionResult,
       _getDetectionResultHistory = getDetectionResultHistory,
       super(DetectionState()) {
    on<StartDetectionEvent>(onDetectionEvent);
    on<DetectionProgressUpdatedEvent>(onProgressUpdated);
    on<StopDetectionEvent>(onStopDetection);
  }

  Future<void> onDetectionEvent(
    StartDetectionEvent event,
    Emitter<DetectionState> emit,
  ) async {
    debugPrint(
      '[DetectionBloc] StartDetectionEvent received: ${event.file.path}',
    );
    emit(state.copyWith(status: ApiLoading()));

    try {
      final result = await _getDetectionResult(
        GetDetectionResultParams(event.file),
        onSendProgress: (sent, total) {
          debugPrint('[DetectionBloc] Upload progress: $sent / $total bytes');
          add(DetectionProgressUpdatedEvent(sent, total));
        },
      );

      result.fold(
        (failure) {
          debugPrint('[DetectionBloc] Detection failed: ${failure.message}');
          if (failure.message == "Cancelled by user") {
            emit(
              state.copyWith(
                status: ApiFailure("Upload cancelled", "CANCELLED"),
              ),
            );
          } else {
            emit(
              state.copyWith(
                status: ApiFailure(failure.message, failure.message),
              ),
            );
          }
        },
        (detectionResult) {
          debugPrint('[DetectionBloc] Detection success: $detectionResult');
          emit(
            state.copyWith(
              status: ApiSuccess(data: detectionResult),
              detectionResult: detectionResult,
            ),
          );
        },
      );
    } catch (e, st) {
      debugPrint('[DetectionBloc] Unexpected error: $e\n$st');
      emit(state.copyWith(status: ApiFailure(e.toString(), 'UNEXPECTED')));
    }
  }

  Future<void> onRestoreHistory(
    RestoreHistoryEvent event,
    Emitter<DetectionState> emit,
  ) async {
    debugPrint(
      '[DetectionBloc] RestoreHistoryEvent for requestId: ${state.detectionResult?.requestId}',
    );
    emit(state.copyWith(status: ApiLoading()));

    try {
      final history = await _getDetectionResultHistory(
        GetDetectionResultHistoryParams(state.detectionResult!.requestId),
      );
      history.fold(
        (failure) {
          debugPrint(
            '[DetectionBloc] History fetch failed: ${failure.message}',
          );
          emit(
            state.copyWith(
              status: ApiFailure(failure.message, failure.message),
            ),
          );
        },
        (detectionResult) {
          debugPrint('[DetectionBloc] History fetched: $detectionResult');
          emit(
            state.copyWith(
              status: ApiSuccess(data: detectionResult),
              detectionResult: detectionResult,
            ),
          );
        },
      );
    } catch (e, st) {
      debugPrint('[DetectionBloc] Unexpected history error: $e\n$st');
      emit(state.copyWith(status: ApiFailure(e.toString(), 'UNEXPECTED')));
    }
  }

  void onProgressUpdated(
    DetectionProgressUpdatedEvent event,
    Emitter<DetectionState> emit,
  ) {
    final progress = (event.total > 0)
        ? ((event.sent / event.total) * 100).floor()
        : 0;
    debugPrint('[DetectionBloc] Progress updated: $progress%');
    emit(state.copyWith(uploadProgress: progress));
  }

  Future<void> onStopDetection(
    StopDetectionEvent event,
    Emitter<DetectionState> emit,
  ) async {
    debugPrint('[DetectionBloc] StopDetectionEvent received');
    if (_cancelToken != null && !_cancelToken!.isCancelled) {
      debugPrint('[DetectionBloc] Cancelling upload…');
      _cancelToken!.cancel("Cancelled by user");
    }
  }
}
