import 'package:true_sight/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:true_sight/features/auth/data/models/user_modal.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> loginWithEmail(String email, String password) {
    // TODO: implement loginWithEmail
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<void> sendOtp(String email) {
    // TODO: implement sendOtp
    throw UnimplementedError();
  }

  @override
  Future<UserModel> signInWithGoogle() {
    // TODO: implement signInWithGoogle
    throw UnimplementedError();
  }

  @override
  Future<UserModel> signup(String name, String email, String password) {
    // TODO: implement signup
    throw UnimplementedError();
  }

  @override
  Future<void> updatePassword(String email, String newPassword) {
    // TODO: implement updatePassword
    throw UnimplementedError();
  }

  @override
  Future<void> verifyOtp(String email, String otp) {
    // TODO: implement verifyOtp
    throw UnimplementedError();
  }
}
