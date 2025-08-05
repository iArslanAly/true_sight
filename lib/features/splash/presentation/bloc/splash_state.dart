part of 'splash_bloc.dart';

class SplashState extends Equatable {
  const SplashState({this.status = const ApiInitial()});
  final ApiStatus status;
  @override
  List<Object> get props => [status];

  SplashState copyWith({ApiStatus? status}) {
    return SplashState(status: status ?? this.status);
  }
}
