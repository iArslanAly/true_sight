import 'dart:io';

import 'package:dio/dio.dart';
import 'package:true_sight/core/error/media/media_exception.dart';
import 'package:true_sight/core/http/dio_clients.dart';
import 'package:true_sight/features/detection/data/datasources/detection_remote_data_source.dart';
import 'package:true_sight/features/detection/data/models/detection_result_model.dart';
import 'package:true_sight/features/detection/data/models/signed_url_model.dart';

class DetectionRemoteDatasourceImpl implements DetectionRemoteDataSource {
  final DioClient _dioClient;

  DetectionRemoteDatasourceImpl(this._dioClient);

  @override
  Future<SignedUrlModel> getSignedUrl(File file) async {
    final response = await _dioClient.postJson(
      '/files/aws-presigned',
      data: {'fileName': file.path.split('/').last},
    );

    // ignore: unrelated_type_equality_checks
    if (response != 200 || response['data'] == null) {
      throw SignedUrlException(response['message']);
    }

    return SignedUrlModel.fromJson(response['data']);
  }

  @override
  Future<void> uploadVideo(
    String signedUrl,
    File file, {
    ProgressCallback? onSendProgress, // <── added
  }) async {
    try {
      await _dioClient.uploadFileToUrl(
        signedUrl,
        file,
        onSendProgress: onSendProgress,
      );
    } on MediaException catch (e) {
      throw UploadException(e.message);
    } catch (e) {
      throw UploadException(e.toString());
    }
  }

  @override
  Future<DetectionResultModel> analyzeVideo(String requestId) async {
    try {
      final response = await _dioClient.getJson('/media/users/$requestId');
      if (response.isEmpty) throw AnalysisException('Empty analysis response');
      return DetectionResultModel.fromJson(response);
    } on MediaException catch (e) {
      throw AnalysisException(e.message);
    } catch (e) {
      throw AnalysisException(e.toString());
    }
  }
}
