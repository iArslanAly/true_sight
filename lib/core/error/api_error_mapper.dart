import 'dart:io';
import 'package:dio/dio.dart';
import 'package:true_sight/core/error/failure.dart';

class ApiErrorMapper {
  /// Convert low-level errors into your Failure classes
  static Failure map(Object error) {
    // Dio transport / HTTP issues
    if (error is DioException) {
      final resp = error.response;
      final data = resp?.data;
      final serverMessage = (data is Map && data['message'] != null)
          ? data['message'].toString()
          : resp?.statusMessage;
      final status = resp?.statusCode;

      // HTTP status mapping
      if (status == 400) {
        return UpdatePasswordFailure(serverMessage ?? 'Invalid request.');
      }
      if (status == 404) {
        return UpdatePasswordFailure(serverMessage ?? 'Email not found.');
      }
      if (status != null && status >= 500) {
        return ServerFailure(
          message: serverMessage ?? 'Server error. Please try again later.',
        );
      }

      // Connection/timeouts
      final type = error.type;
      if (type == DioExceptionType.connectionError ||
          type == DioExceptionType.sendTimeout ||
          type == DioExceptionType.receiveTimeout) {
        return const ServerUnreachableFailure();
      }

      // fallback
      return UnknownAuthFailure();
    }

    // Socket-level network error
    if (error is SocketException) {
      return const ServerUnreachableFailure();
    }

    // Response parse problems
    if (error is FormatException) {
      return ServerFailure(message: 'Invalid server response.');
    }

    // Unknown
    return const UnknownAuthFailure();
  }
}
