// get_result.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:true_sight/core/error/failure.dart';
import 'package:true_sight/core/utils/usecase/usecases.dart';
import 'package:true_sight/features/detection/domain/entities/detection_result_entity.dart';
import 'package:true_sight/features/detection/domain/repositories/detection_repository.dart';

/// UseCase to analyze a local file and return a DetectionResultEntity
/// Params type is GetDetectionResultParams so the generic matches the call signature.
class GetDetectionResult
    extends UseCase<DetectionResultEntity, GetDetectionResultParams> {
  final DetectionRepository repository;

  GetDetectionResult(this.repository);

  @override
  Future<Either<Failure, DetectionResultEntity>> call(
    GetDetectionResultParams params, {
    ProgressCallback? onSendProgress,
  }) async {
    // Optionally check size / type here before sending to repository
    return repository.analyzeVideo(params.file, onSendProgress: onSendProgress);
  }
}

class GetDetectionResultParams {
  final File file;

  GetDetectionResultParams(this.file);
}
