import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:true_sight/core/error/failure.dart';
import 'package:true_sight/core/utils/status/auth_status.dart';
import 'package:true_sight/features/auth/domain/entities/user_entity.dart';
import 'package:true_sight/features/auth/domain/usecases/get_logged_in_user.dart';
import 'package:true_sight/features/auth/domain/usecases/resend_verification_email.dart';
import 'package:true_sight/features/auth/domain/usecases/send_otp.dart';
import 'package:true_sight/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:true_sight/features/auth/domain/usecases/update_password.dart';
import 'package:true_sight/features/auth/domain/usecases/update_profile_image.dart';
import 'package:true_sight/features/auth/domain/usecases/user_login.dart';
import 'package:true_sight/features/auth/domain/usecases/user_logout.dart';
import 'package:true_sight/features/auth/domain/usecases/user_signup.dart';
import 'package:true_sight/features/auth/domain/usecases/verify_otp.dart';

import '../../../../core/utils/usecase/usecases.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser _loginUser;
  final SignupUser _signupUser;
  final SignInWithGoogle _signInWithGoogle;
  final UserLogout _userLogout;
  final ResendVerificationEmail _resendVerificationEmail;
  final SendOtp _sendOtp;
  final VerifyOtp _verifyOtp;
  final UpdatePassword _updatePassword;
  final GetLoggedInUser _getLoggedInUser;
  final UpdateProfileImage _updateProfileImage;

  AuthBloc({
    required LoginUser loginUser,
    required SignupUser signupUser,
    required SignInWithGoogle signInWithGoogle,
    required UserLogout userLogout,
    required ResendVerificationEmail resendVerificationEmail,
    required SendOtp sendOtp,
    required VerifyOtp verifyOtp,
    required UpdatePassword updatePassword,
    required GetLoggedInUser getLoggedInUser,
    required UpdateProfileImage updateProfileImage,
  }) : _loginUser = loginUser,
       _signupUser = signupUser,
       _signInWithGoogle = signInWithGoogle,
       _userLogout = userLogout,
       _resendVerificationEmail = resendVerificationEmail,
       _updateProfileImage = updateProfileImage,
       _getLoggedInUser = getLoggedInUser,
       _verifyOtp = verifyOtp,
       _sendOtp = sendOtp,
       _updatePassword = updatePassword,
       super(const AuthState()) {
    on<AuthLoginEvent>(_onAuthLoginEvent);
    on<AuthSignupEvent>(_onAuthSignupEvent);
    on<AuthGoogleLoginEvent>(_onGoogleLoginEvent);
    on<AuthLogoutEvent>(_onAuthLogoutEvent);
    on<AuthResetEvent>(_onAuthResetEvent);
    on<AuthResendVerifyEmailEvent>(_onResendVerifyEmail);
    on<AuthSendOtpEvent>(_onSendOtpEvent);
    on<AuthVerifyOtpEvent>(_onVerifyOtpEvent);
    on<AuthUpdatePasswordEvent>(_onAuthUpdatePasswordEvent);
    on<AuthGetLoggedInUserEvent>(_onGetLoggedinUserEvent);
    on<AuthUpdateProfileImageEvent>(_onUpdateProfileImageEvent);
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
      (failure) async {
        if (failure is EmailNotVerifiedFailure) {
          emit(
            state.copyWith(
              status: AuthFailure(failure.message, isEmailNotVerified: true),
            ),
          );
        } else {
          emit(state.copyWith(status: AuthFailure(failure.message)));
        }
      },
      (userEntity) async {
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
        emit(state.copyWith(status: AuthFailure(failure.message)));
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
    emit(state.copyWith(status: AuthLoading()));
    final user = await _signInWithGoogle.call(NoParams());
    user.fold(
      (failure) {
        emit(state.copyWith(status: AuthFailure(failure.message)));
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
    emit(state.copyWith(status: AuthLoggedOut()));
    final user = await _userLogout.call(NoParams());
    user.fold(
      (failure) {
        emit(state.copyWith(status: AuthFailure(failure.message)));
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

  Future<void> _onResendVerifyEmail(
    AuthResendVerifyEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthLoading()));
    final result = await _resendVerificationEmail.call(NoParams());
    result.fold(
      (failure) {
        emit(state.copyWith(status: AuthFailure(failure.message)));
      },
      (_) {
        emit(
          state.copyWith(
            status: const AuthResendEmailSuccess(
              'Verification email resent successfully',
            ),
          ),
        );
      },
    );
  }

  Future<void> _onSendOtpEvent(
    AuthSendOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthLoading()));
    final result = await _sendOtp.call(SendOtpParams(email: event.email));
    result.fold(
      (failure) {
        emit(state.copyWith(status: AuthFailure(failure.message)));
      },
      (_) {
        emit(
          state.copyWith(
            status: const AuthSuccess(
              message: 'OTP sent successfully',
              otpSent: true,
            ),
          ),
        );
      },
    );
  }

  Future<void> _onVerifyOtpEvent(
    AuthVerifyOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthLoading()));
    final result = await _verifyOtp.call(otp: event.otp);
    result.fold(
      (failure) {
        emit(state.copyWith(status: AuthFailure(failure.message)));
      },
      (_) {
        emit(
          state.copyWith(
            status: const AuthSuccess(
              message: 'OTP verified successfully',
              otpVerified: true,
            ),
          ),
        );
      },
    );
  }

  Future<void> _onAuthUpdatePasswordEvent(
    AuthUpdatePasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthLoading()));
    final result = await _updatePassword.call(
      UpdatePasswordParams(email: event.email, newPassword: event.newPassword),
    );
    result.fold(
      (failure) {
        emit(state.copyWith(status: AuthFailure(failure.message)));
      },
      (_) {
        emit(
          state.copyWith(
            status: const AuthSuccess(message: 'Password updated successfully'),
          ),
        );
      },
    );
  }

  Future<void> _onGetLoggedinUserEvent(
    AuthGetLoggedInUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthLoading()));
    final user = await _getLoggedInUser.call(NoParams());
    user.fold(
      (failure) {
        emit(state.copyWith(status: AuthFailure(failure.message)));
      },
      (userEntity) {
        emit(
          state.copyWith(
            status: AuthSuccess(data: userEntity),
            user: userEntity,
          ),
        );
      },
    );
  }

  Future<void> _onUpdateProfileImageEvent(
    AuthUpdateProfileImageEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthLoading()));
    final result = await _updateProfileImage.call(event.imageFile);
    result.fold(
      (failure) {
        emit(state.copyWith(status: AuthFailure(failure.message)));
      },
      (userEntity) {
        emit(
          state.copyWith(
            status: AuthSuccess(data: userEntity),
            user: userEntity,
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
