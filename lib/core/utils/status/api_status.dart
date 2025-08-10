import 'package:meta/meta.dart';

@immutable
abstract class ApiStatus {
  const ApiStatus();

  get showSettings => null;
}

class ApiInitial extends ApiStatus {
  const ApiInitial();
}

class ApiLoading extends ApiStatus {}

class ApiSuccess extends ApiStatus {
  final dynamic data;
  final String message;

  const ApiSuccess({this.data, this.message = ''});
}

class ApiFailure extends ApiStatus {
  final dynamic errorCode;
  final String errorMessage;
  @override
  final bool showSettings;

  const ApiFailure(
    this.errorCode,
    this.errorMessage, {
    this.showSettings = false,
  });
}
