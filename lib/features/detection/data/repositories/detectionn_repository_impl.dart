import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:true_sight/core/error/failure.dart';
import 'package:true_sight/core/error/media/media_exception.dart';
import 'package:true_sight/core/error/media/media_exception_to_failure.dart';
import 'package:true_sight/features/detection/data/datasources/detection_remote_data_source.dart';
import 'package:true_sight/features/detection/domain/entities/detection_result_entity.dart';
import 'package:true_sight/features/detection/domain/repositories/detection_repository.dart';

class DetectionRepositoryImpl implements DetectionRepository {
  final DetectionRemoteDataSource remoteDataSource;

  DetectionRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, DetectionResultEntity>> analyzeVideo(
    File file, {
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final signedUrlResponse = await remoteDataSource.getSignedUrl(file);
      debugPrint(' Repository : About to call uploadVideo');
      debugPrint(' Repository : Signed URL => ${signedUrlResponse.signedUrl}');
      await remoteDataSource.uploadVideo(
        signedUrlResponse.signedUrl,
        file,
        onSendProgress: onSendProgress,
      );
      final resultModel = await remoteDataSource.analyzeVideo(
        signedUrlResponse.requestId,
      );
      debugPrint(' Repository : Analysis result model => $resultModel');
      return Right(resultModel.toEntity());
    } on MediaException catch (e) {
      return Left(MediaExceptionToFailure.map(e));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, DetectionResultEntity>> getDetectionResultHistory(
    String requestId,
  ) async {
    try {
      final resultModel = await remoteDataSource.analyzeVideo(requestId);
      return Right(resultModel.toEntity());
    } on MediaException catch (e) {
      return Left(MediaExceptionToFailure.map(e));
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }
}
