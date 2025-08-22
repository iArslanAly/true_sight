import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:true_sight/core/error/failure.dart';
import 'package:true_sight/features/detection/domain/entities/detection_result_entity.dart';

abstract class DetectionRepository {
  Future<Either<Failure, DetectionResultEntity>> analyzeVideo(
    File file, {
    ProgressCallback? onSendProgress,
  });
  Future<Either<Failure, DetectionResultEntity>> getDetectionResultHistory(
    String requestId,
  );
}
