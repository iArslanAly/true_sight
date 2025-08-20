import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:true_sight/core/constants/api_constants.dart';
import 'package:true_sight/core/logging/logger.dart';

class DioClient {
  // Singleton instance
  DioClient._privateConstructor();
  static final DioClient instance = DioClient._privateConstructor();

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(minutes: 2),
      receiveTimeout: const Duration(minutes: 5),
      headers: {'x-api-key': dotenv.env['REALITY_DEFENDER_API'] ?? ''},
    ),
  );

  void configForRealityDefender() {
    final apiKey = dotenv.env['REALITY_DEFENDER_API'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('Missing RD api_key in .env');
    }

    _dio.options.baseUrl = 'https://api.prd.realitydefender.xyz/api';
    _dio.options.headers['x-api-key'] = apiKey;

    // Add logging interceptor
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
        logPrint: (obj) => XLoggerHelper.debug(obj.toString()),
      ),
    );
  }

  Future<ApiResponse> getSignedUrl(String fileName) async {
    try {
      final response = await _dio.post(
        '/files/aws-presigned',
        data: {'fileName': fileName},
      );
      return ApiResponse.success(response.data, response.statusCode ?? 200);
    } on DioException catch (e) {
      return _handleError(e);
    } catch (e) {
      return ApiResponse.error('Unexpected error: $e', 500);
    }
  }

  Future<ApiResponse> uploadToS3(
    String signedUrl,
    String filePath, {
    ProgressCallback? onProgress,
  }) async {
    try {
      final fileBytes = await File(filePath).readAsBytes();
      final response = await _dio.put(
        signedUrl,
        data: fileBytes,
        onSendProgress: onProgress,
        options: Options(headers: {'Content-Type': 'application/octet-stream'}),
      );
      return ApiResponse.success(response.data, response.statusCode);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<ApiResponse> getAnalysisResult(String requestId) async {
    try {
      final response = await _dio.get('/media/users/$requestId/');
      return ApiResponse.success(response.data, response.statusCode);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<ApiResponse> post(
    String endpoint, {
    dynamic data,
    ProgressCallback? onSendProgress,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        onSendProgress: onSendProgress,
      );
      return ApiResponse.success(response.data, response.statusCode);
    } catch (e) {
      return _handleError(e);
    }
  }

  ApiResponse _handleError(dynamic error) {
    if (error is DioException) {
      final message =
          error.response?.data['message'] ??
          error.response?.statusMessage ??
          error.message ??
          'Unknown error';
      return ApiResponse.error(message.toString(), error.response?.statusCode);
    }
    return ApiResponse.error('Unexpected error: $error', null);
  }
}
