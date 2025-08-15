import 'dart:io';

import 'package:true_sight/features/auth/data/models/user_modal.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel?> loginWithEmail(String email, String password);
  Future<UserModel?> signup(String name, String email, String password);
  Future<UserModel?> signInWithGoogle();
  Future<void> reloadUser();
  Future<UserModel?> getCurrentUser();
  Future<void> resendVerificationEmail();
  Future<bool> isEmailVerified();
  Future<void> sendOtp(String email);
  Future<void> verifyOtp(String otp);
  Future<void> updatePassword(String email, String newPassword);
  Future<void> logout();
  Future<UserModel> updateProfileImage(File imageFile);
}
