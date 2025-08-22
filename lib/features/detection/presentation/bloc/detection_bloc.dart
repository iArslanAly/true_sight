import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
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
    emit(state.copyWith(status: ApiLoading()));
    final result = await _getDetectionResult(
      GetDetectionResultParams(event.file),
      onSendProgress: (sent, total) {
        add(DetectionProgressUpdatedEvent(sent, total));
      },
    );
    result.fold(
      (failure) {
        if (CancelToken.isCancel(failure.message as DioException)) {
          emit(
            state.copyWith(status: ApiFailure("Upload cancelled", "CANCELLED")),
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
        emit(
          state.copyWith(
            status: ApiSuccess(data: detectionResult),
            detectionResult: detectionResult,
          ),
        );
      },
    );
  }

  Future<void> onRestoreHistory(
    RestoreHistoryEvent event,
    Emitter<DetectionState> emit,
  ) async {
    emit(state.copyWith(status: ApiLoading()));
    final history = await _getDetectionResultHistory(
      GetDetectionResultHistoryParams(state.detectionResult!.requestId),
    );
    history.fold(
      (failure) => emit(
        state.copyWith(status: ApiFailure(failure.message, failure.message)),
      ),
      (detectionResult) => emit(
        state.copyWith(
          status: ApiSuccess(data: detectionResult),
          detectionResult: detectionResult,
        ),
      ),
    );
  }

  void onProgressUpdated(
    DetectionProgressUpdatedEvent event,
    Emitter<DetectionState> emit,
  ) {
    final progress = (event.total > 0)
        ? ((event.sent / event.total) * 100).floor()
        : 0;

    emit(state.copyWith(uploadProgress: progress));
  }

  Future<void> onStopDetection(
    StopDetectionEvent event,
    Emitter<DetectionState> emit,
  ) async {
    if (_cancelToken != null && !_cancelToken!.isCancelled) {
      _cancelToken!.cancel("Cancelled by user");
    }
  }
}
