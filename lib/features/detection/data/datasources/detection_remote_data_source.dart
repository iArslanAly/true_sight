import 'dart:io';

import 'package:dio/dio.dart';
import 'package:true_sight/features/detection/data/models/detection_result_model.dart';
import 'package:true_sight/features/detection/data/models/signed_url_model.dart';

abstract class DetectionRemoteDataSource {
  Future<SignedUrlModel> getSignedUrl(File file);
  Future<void> uploadVideo(
    String signedUrl,
    File file, {
    ProgressCallback? onSendProgress,
  });
  Future<DetectionResultModel> analyzeVideo(String requestedId);
}
