import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:true_sight/core/logging/logger.dart';
import 'package:true_sight/core/utils/status/auth_status.dart';
import 'package:true_sight/features/auth/domain/entities/user_entity.dart';
import 'package:true_sight/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:true_sight/features/auth/domain/usecases/user_login.dart';
import 'package:true_sight/features/auth/domain/usecases/user_logout.dart';
import 'package:true_sight/features/auth/domain/usecases/user_signup.dart';

import '../../../../core/utils/status/usecases.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser _loginUser;
  final SignupUser _signupUser;
  final SignInWithGoogle _signInWithGoogle;
  final UserLogout _userLogout;
  AuthBloc({
    required LoginUser loginUser,
    required SignupUser signupUser,
    required SignInWithGoogle signInWithGoogle,
    required UserLogout userLogout,
  }) : _loginUser = loginUser,
       _signupUser = signupUser,
       _signInWithGoogle = signInWithGoogle,
       _userLogout = userLogout,
       super(const AuthState()) {
    on<AuthLoginEvent>(_onAuthLoginEvent);
    on<AuthSignupEvent>(_onAuthSignupEvent);
    on<AuthGoogleLoginEvent>(_onGoogleLoginEvent);
    on<AuthLogoutEvent>(_onAuthLogoutEvent);
    on<AuthResetEvent>(_onAuthResetEvent);
  }
  Future<void> _onAuthLoginEvent(
    AuthLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthLoading()));
    final user = await _loginUser(
      LoginUserParams(email: event.email, password: event.password),
    );
    user.fold(
      (failure) {
        emit(
          state.copyWith(status: AuthFailure(failure.message, failure.message)),
        );
      },
      (userEntity) {
        emit(
          state.copyWith(
            status: AuthSuccess(data: userEntity),
            email: event.email,
            user: userEntity,
          ),
        );
      },
    );
  }

  Future<void> _onAuthSignupEvent(
    AuthSignupEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthLoading()));
    final user = await _signupUser(
      SignupParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );
    user.fold(
      (failure) {
        emit(
          state.copyWith(status: AuthFailure(failure.message, failure.message)),
        );
      },
      (userEntity) {
        emit(
          state.copyWith(
            status: AuthSuccess(data: userEntity),
            email: event.email,
            user: userEntity,
          ),
        );
      },
    );
  }

  Future<void> _onGoogleLoginEvent(
    AuthGoogleLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    XLoggerHelper.debug('Attempting Google login...');
    emit(state.copyWith(status: AuthLoading()));
    final user = await _signInWithGoogle.call(NoParams());
    XLoggerHelper.debug(
      'Google login result: ${user.isLeft() ? 'Failure' : 'Success'}',
    );
    user.fold(
      (failure) {
        emit(
          state.copyWith(status: AuthFailure(failure.message, failure.message)),
        );
      },
      (userEntity) {
        emit(
          state.copyWith(
            status: AuthSuccess(data: userEntity),
            email: userEntity.email,
            user: userEntity,
          ),
        );
      },
    );
  }

  Future<void> _onAuthLogoutEvent(
    AuthLogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthLoading()));
    final user = await _userLogout.call(NoParams());
    user.fold(
      (failure) {
        emit(
          state.copyWith(status: AuthFailure(failure.message, failure.message)),
        );
      },
      (_) {
        emit(
          state.copyWith(
            status: const AuthSuccess(message: 'Logged out successfully'),
            email: '',
            user: null,
          ),
        );
      },
    );
  }

  Future<void> _onAuthResetEvent(
    AuthResetEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthInitial()));
  }
}
