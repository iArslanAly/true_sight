import 'package:fpdart/fpdart.dart';
import 'package:true_sight/core/error/failure.dart';
import 'package:true_sight/core/utils/usecase/usecases.dart';
import 'package:true_sight/features/detection/domain/entities/detection_result_entity.dart';
import 'package:true_sight/features/detection/domain/repositories/detection_repository.dart';

class GetDetectionResultHistory
    extends UseCase<DetectionResultEntity, GetDetectionResultHistoryParams> {
  final DetectionRepository repository;

  GetDetectionResultHistory(this.repository);

  @override
  Future<Either<Failure, DetectionResultEntity>> call(
    GetDetectionResultHistoryParams params,
  ) async {
    return await repository.getDetectionResultHistory(params.requestId);
  }
}

class GetDetectionResultHistoryParams {
  final String requestId;

  GetDetectionResultHistoryParams(this.requestId);
}
