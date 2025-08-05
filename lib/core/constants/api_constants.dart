import 'package:true_sight/core/enums/enums.dart';

class ApiResponse {
  final ApiResponseStatus status;
  final dynamic data;
  final String? message;
  final int? statusCode;

  const ApiResponse({
    required this.status,
    this.data,
    this.message,
    this.statusCode,
  });

  factory ApiResponse.success(dynamic data, [int? statusCode]) => ApiResponse(
    status: ApiResponseStatus.success,
    data: data,
    statusCode: statusCode,
  );

  factory ApiResponse.error(String message, [int? statusCode]) => ApiResponse(
    status: ApiResponseStatus.error,
    message: message,
    statusCode: statusCode,
  );
}
