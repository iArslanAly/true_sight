import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mime/mime.dart';

import 'package:true_sight/core/error/media/media_exception.dart';
import 'package:true_sight/core/http/dio_clients.dart';
import 'package:true_sight/features/detection/data/datasources/detection_remote_data_source.dart';
import 'package:true_sight/features/detection/data/models/detection_result_model.dart';
import 'package:true_sight/features/detection/data/models/signed_url_model.dart';

class DetectionRemoteDataSourceImpl implements DetectionRemoteDataSource {
  final DioClient dioClient;
  DetectionRemoteDataSourceImpl(this.dioClient);

  @override
  Future<SignedUrlModel> getSignedUrl(File file) async {
    try {
      final response = await dioClient.postJson(
        '/files/aws-presigned',
        data: {'fileName': file.path.split('/').last},
      );

      print('Signed URL response: $response');

      // Validate fields in their real places
      if (response['response'] == null ||
          response['response']['signedUrl'] == null ||
          response['requestId'] == null ||
          response['mediaId'] == null) {
        throw SignedUrlException('Invalid signed URL response');
      }

      return SignedUrlModel.fromJson(response);
    } on DioException catch (e) {
      throw SignedUrlException(_mapDioError(e));
    }
  }

  @override
  Future<void> uploadVideo(
    String signedUrl,
    File file, {
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
      await dioClient.uploadFileToUrl(
        signedUrl,
        file,
        extraHeaders: {'Content-Type': mimeType},
        onSendProgress: onSendProgress,
      );
    } on DioException catch (e) {
      throw UploadException(_mapDioError(e));
    }
  }

  @override
  Future<DetectionResultModel> analyzeVideo(String requestId) async {
    await Future.delayed(const Duration(seconds: 2));
    final response = await dioClient.getJson('/media/users/$requestId');
    print('Raw analysis response: $response');

    // If the server gives you a valid result right away, just return it
    return DetectionResultModel.fromJson(response);
  }
}

String _mapDioError(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return 'Connection timed out';
    case DioExceptionType.badResponse:
      final status = e.response?.statusCode;
      final msg = e.response?.data?['message'] ?? e.message;
      return 'Server error ($status): $msg';
    case DioExceptionType.connectionError:
      return 'No internet connection';
    case DioExceptionType.cancel:
      return 'Request was cancelled';
    default:
      return 'Unexpected error: ${e.message}';
  }
}
