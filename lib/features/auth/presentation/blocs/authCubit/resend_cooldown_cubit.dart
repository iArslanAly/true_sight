import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResendCooldownCubit extends Cubit<int> {
  ResendCooldownCubit() : super(0);
  Timer? _timer;

  void startCooldown([int seconds = 60]) {
    emit(seconds);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state <= 1) {
        timer.cancel();
        emit(0);
      } else {
        emit(state - 1);
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
