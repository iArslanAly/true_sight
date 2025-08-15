// usecases.dart
import 'package:fpdart/fpdart.dart';
import '../../error/failure.dart';

// ignore: avoid_types_as_parameter_names
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {}
