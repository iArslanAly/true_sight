// api_exception.dart
import 'package:true_sight/core/error/failure.dart';

class ApiException implements Exception {
  final Failure failure;
  ApiException(this.failure);
  @override
  String toString() => 'ApiException: ${failure.message}';
}
