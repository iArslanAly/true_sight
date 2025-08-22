import 'package:true_sight/core/error/media/media_exception.dart';
import 'package:true_sight/core/error/failure.dart';

class MediaExceptionToFailure {
  static Failure map(Object e) {
    if (e is SignedUrlException) {
      return ServerFailure(message: e.message ?? "Failed to get signed URL");
    }
    if (e is UploadException) {
      return ServerFailure(message: e.message ?? "Failed to upload media");
    }
    if (e is AnalysisException) {
      return ServerFailure(message: e.message ?? "Failed to analyze media");
    }
    if (e is NetworkException) {
      return const NetworkFailure();
    }
    if (e is TimeoutException) {
      return const ServerUnreachableFailure();
    }

    return const UnknownFailure();
  }
}
