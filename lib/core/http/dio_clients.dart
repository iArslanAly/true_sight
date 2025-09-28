// dio_client.dart
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:true_sight/core/logging/logger.dart';
import 'package:true_sight/core/error/media/media_exception.dart';

/// Thin HTTP adapter. Responsible only for making HTTP requests and mapping
/// network/HTTP/timeout errors into MediaException subclasses.
/// Parsing of API response to models should happen in the RemoteDataSource.
class DioClient {
  DioClient._privateConstructor();
  static final DioClient instance = DioClient._privateConstructor();

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 60),
      // baseUrl will be set by configForRealityDefender
    ),
  );

  /// Call once during app init (or when needed).
  void configForRealityDefender() {
    final apiKey = dotenv.env['REALITY_DEFENDER_API'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('Missing REALITY_DEFENDER_API in .env');
    }

    _dio.options.baseUrl = 'https://api.prd.realitydefender.xyz/api';
    _dio.options.headers['x-api-key'] = apiKey;

    if (!_dio.interceptors.any((i) => i is LogInterceptor)) {
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
  }

  /// POST expecting JSON object response.
  /// Throws MediaException on any error.
  Future<Map<String, dynamic>> postJson(
    String endpoint, {
    dynamic data,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
    Map<String, dynamic>? extraHeaders,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        options: Options(headers: extraHeaders),
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );
      return _ensureMap(response.data);
    } on DioException catch (e) {
      throw _mapDioException(e);
    } catch (e) {
      throw UnknownMediaException(e.toString());
    }
  }

  /// GET expecting JSON object response.
  Future<Map<String, dynamic>> getJson(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return _ensureMap(response.data);
    } on DioException catch (e) {
      throw _mapDioException(e);
    } catch (e) {
      throw UnknownMediaException(e.toString());
    }
  }

  /// Upload raw bytes to a presigned URL (S3). Uses a fresh Dio instance to
  /// avoid interfering with baseUrl / interceptors.
  Future<void> putBytesToUrl(
    String signedUrl,
    Uint8List bytes, {
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
    Map<String, dynamic>? extraHeaders,
  }) async {
    try {
      final dioForUpload = Dio(
        BaseOptions(
          // Uploads can be slow; increase timeouts
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 120),
        ),
      );

      final options = Options(
        headers: {
          'Content-Type': 'application/octet-stream',
          if (extraHeaders != null) ...extraHeaders,
        },
        responseType: ResponseType.plain,
      );

      // Use a Stream so large files don't get double-buffered
      final stream = Stream<List<int>>.fromIterable(<List<int>>[bytes]);

      await dioForUpload.put(
        signedUrl,
        data: stream,
        options: options,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    } catch (e) {
      throw UnknownMediaException(e.toString());
    }
  }

  /// Convenience: upload a File (reads bytes then calls putBytesToUrl)
  Future<void> uploadFileToUrl(
    String url,
    File file, {
    Map<String, String>? extraHeaders,
    ProgressCallback? onSendProgress,
  }) async {
    final dio = Dio();
    try {
      final bytes = await file.readAsBytes();
      final response = await dio.put(
        url,
        data: bytes,
        options: Options(
          headers: extraHeaders,
          responseType: ResponseType.plain,
        ),
        onSendProgress: onSendProgress,
      );
      debugPrint(
        'S3 upload response: ${response.statusCode} ${response.statusMessage}',
      );
    } catch (e, st) {
      debugPrint('Upload error: $e\n$st');
      rethrow;
    }
  }

  /// Ensure the response body is a JSON object and return as Map.
  Map<String, dynamic> _ensureMap(dynamic data) {
    if (data == null) return <String, dynamic>{};
    if (data is Map<String, dynamic>) return data;
    if (data is String) {
      try {
        final parsed = jsonDecode(data);
        if (parsed is Map<String, dynamic>) return parsed;
      } catch (_) {}
    }
    throw UnknownMediaException('Response is not a JSON object');
  }

  /// Map DioException to your MediaException hierarchy.
  MediaException _mapDioException(DioException e) {
    // Dio v5 types
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(e.message ?? 'Request timed out');
      case DioExceptionType.cancel:
        return NetworkException('Request cancelled');
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        return NetworkException(e.message ?? 'Network error');
      case DioExceptionType.badResponse:
        final status = e.response?.statusCode;
        final raw = e.response?.data;
        final msg = raw is Map
            ? raw['message'] ?? e.response?.statusMessage
            : e.response?.statusMessage;
        return UnknownMediaException('HTTP $status: ${msg ?? e.message}');
      default:
        return UnknownMediaException(e.message ?? 'Unknown network error');
    }
  }
}
