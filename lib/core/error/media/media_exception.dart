class MediaException implements Exception {
  final String? message;

 const MediaException(this.message);

  @override
  String toString() {
    return 'MediaException: $message';
  }
}

class SignedUrlException extends MediaException {
  const SignedUrlException([super.message]);
}
class UploadException extends MediaException {
  const UploadException([super.message]);
}

class AnalysisException extends MediaException {
  const AnalysisException([super.message]);
}

class NetworkException extends MediaException {
  const NetworkException([super.message]);
}

class TimeoutException extends MediaException {
  const TimeoutException([super.message]);
}

class UnknownMediaException extends MediaException {
  const UnknownMediaException([super.message]);
}
