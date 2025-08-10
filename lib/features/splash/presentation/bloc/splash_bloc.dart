import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:true_sight/core/utils/status/api_status.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashState()) {
    on<SplashStarted>(onStart);
  }

  void onStart(SplashStarted event, Emitter<SplashState> emit) async {
    emit(state.copyWith(status: ApiLoading()));
    await Future.delayed(Duration(seconds: 3));
    emit(state.copyWith(status: ApiSuccess()));
  }
}
