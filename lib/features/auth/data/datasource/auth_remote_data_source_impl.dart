import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:true_sight/core/error/api_error_mapper.dart';
import 'package:true_sight/core/error/api_exception.dart';
import 'package:true_sight/core/error/auth_exceptions.dart';
import 'package:true_sight/core/error/failure.dart';
import 'package:true_sight/core/error/firebase_auth_exception_mapper.dart.dart';
import 'package:true_sight/core/formaters/formaters.dart';
import 'package:true_sight/core/logging/logger.dart';
import 'package:true_sight/core/services/otp_config_service.dart';
import 'package:true_sight/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:true_sight/features/auth/data/models/user_modal.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;
  final Connectivity _connectivity;
  final FirebaseStorage _firebaseStorage;

  AuthRemoteDataSourceImpl({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
    required GoogleSignIn googleSignIn,
    required Connectivity connectivity,
    required FirebaseStorage firebaseStorage,
  }) : _firebaseAuth = firebaseAuth,
       _firestore = firestore,
       _googleSignIn = googleSignIn,
       _connectivity = connectivity,
       _firebaseStorage = firebaseStorage;

  UserModel _mapUserModel(User user, String provider) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? '',
      photoUrl: user.photoURL ?? '',
      provider: provider,
      emailVerified: user.emailVerified,
      createdAt: null,
    );
  }

  Future<void> _createUserDoc(User user, String provider) async {
    final userDoc = _firestore.collection('users').doc(user.uid);
    final userModel = _mapUserModel(user, provider);

    await userDoc.set({
      ...userModel.toJson(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<UserModel?> loginWithEmail(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password)
          .timeout(const Duration(seconds: 30));
      final user = userCredential.user;
      if (user == null) {
        throw const UserNotFoundException();
      }

      await user.reload();
      final refreshedUser = _firebaseAuth.currentUser!;
      if (!refreshedUser.emailVerified) {
        throw const EmailNotVerifiedException();
      }

      await _createUserDoc(user, 'email');
      return _mapUserModel(user, 'email');
    } on FirebaseAuthException catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: 'Login failed: ${e.code} - ${e.message}',
        information: ['Email: $email'], // optional metadata
      );
      throw FirebaseAuthExceptionMapper.map(e);
    } on TimeoutException catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: 'Signing timed out',
      );
      throw const SigninTimeoutException();
    } on SocketException catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s, reason: 'Network error');
      throw const NetworkException();
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: 'Unknown signing error',
      );
      // if it's a known Exception rethrow; else wrap to UnknownAuthException
      if (e is AuthException) rethrow;
      throw UnknownAuthException(e.toString());
    }
  }

  @override
  Future<UserModel?> signup(String name, String email, String password) async {
    try {
      final userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .timeout(const Duration(seconds: 30));

      final user = userCredential.user;
      if (user == null) {
        throw const UserCreationFailure();
      }

      // Set display name
      await user.updateDisplayName(name);

      // Optional: Reload user to ensure updated displayName is reflected
      await user.reload();
      final updatedUser = _firebaseAuth.currentUser;

      // Send email verification
      await user.sendEmailVerification();

      // Create user document in Firestore
      await _createUserDoc(updatedUser!, 'email');

      return _mapUserModel(updatedUser, 'email');
    } on FirebaseAuthException catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s, reason: 'Signup failed');
      throw FirebaseAuthExceptionMapper.map(e);
    } on TimeoutException catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: 'Signup timed out',
      );
      throw const SignupTimeoutFailure();
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: 'Unknown signup error',
      );
      throw const UnknownAuthException();
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s, reason: 'Logout failed');
    }
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    try {
      await _googleSignIn.initialize();
      final account = await _googleSignIn.authenticate();
      final auth = account.authentication;
      final userCredential = GoogleAuthProvider.credential(
        idToken: auth.idToken,
      );
      final userCredentialResult = await _firebaseAuth
          .signInWithCredential(userCredential)
          .timeout(const Duration(seconds: 30));
      final user = userCredentialResult.user;
      if (user == null) {
        throw const UserNotFoundFailure();
      }
      await _createUserDoc(user, 'google');
      return _mapUserModel(user, 'google');
    } on FirebaseAuthException catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: 'Google sign-in failed',
      );
      throw FirebaseAuthExceptionMapper.map(e);
    } on TimeoutException catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: ' Google Sign-in timed out',
      );
      throw const SigninTimeoutFailure();
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: 'Unknown Google sign-in error',
      );
      throw const UnknownAuthFailure();
    }
  }

  @override
  Future<void> updatePassword(String email, String newPassword) async {
    const String baseUrl = 'http://192.168.100.6:3000';
    final dio = Dio();

    try {
      final response = await dio.post(
        '$baseUrl/reset-password',
        data: {'email': email, 'newPassword': newPassword},
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (_) => true,
        ),
      );

      final status = response.statusCode ?? 0;
      final body = response.data;

      String? serverMessage;
      if (body == null) {
        serverMessage = null;
      } else if (body is String && body.trim().isNotEmpty) {
        serverMessage = body;
      } else if (body is Map) {
        serverMessage = (body['message'] ?? body['error'] ?? body['msg'])
            ?.toString();
      } else {
        serverMessage = body.toString();
      }

      if (status >= 200 && status < 300) return;

      if (status >= 400 && status < 500) {
        throw UpdatePasswordFailure(
          serverMessage ?? 'Request failed (status: $status).',
        );
      }

      if (status >= 500) {
        throw ServerFailure(
          message: serverMessage ?? 'Server error (status: $status).',
        );
      }

      // Fallback – shouldn't be hit now
      throw UpdatePasswordFailure(
        serverMessage ?? 'Unexpected response (status: $status).',
      );
    } on DioException catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: 'updatePassword DioException',
        fatal: false,
      );
      final failure = ApiErrorMapper.map(e);
      throw ApiException(failure);
    } on SocketException catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: 'updatePassword SocketException',
        fatal: false,
      );
      final failure = ApiErrorMapper.map(e);
      throw ApiException(failure);
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: 'updatePassword unknown error',
        fatal: false,
      );
      if (e is Failure) {
        throw ApiException(e); // wrap existing failure
      }
      final failure = ApiErrorMapper.map(e);
      throw ApiException(failure);
    }
  }

  @override
  Future<void> sendOtp(String email) async {
    try {
      final templateWithTime = OTPConfigService.otpTemplate
          .replaceAll('{{year}}', currentYear())
          .replaceAll('{{dateTime}}', formattedDateTime());

      // Apply the updated template before sending
      EmailOTP.setTemplate(template: templateWithTime);

      final isSent = await EmailOTP.sendOTP(email: email);
      if (!isSent) {
        throw OtpSendFailure();
      }
    } on TimeoutException catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: 'OTP sending timed out',
      );
      throw OtpTimeoutFailure();
    } on OtpSendFailure {
      rethrow;
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: 'Unexpected OTP send error',
      );

      throw const UnknownAuthException();
    }
  }

  @override
  Future<void> verifyOtp(String otp) async {
    try {
      // Static call — returns bool
      final isValid = EmailOTP.verifyOTP(otp: otp);
      if (!isValid) {
        throw InvalidOtpFailure();
      }
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: 'Unexpected OTP verify error',
      );
      if (e is InvalidOtpFailure) {
        rethrow; // propagate InvalidOtpFailure upwards
      }
      throw const UnknownAuthException();
    }
  }

  @override
  Future<void> resendVerificationEmail() async {
    try {
      final user = _firebaseAuth.currentUser;
      await user?.reload();
      if (user == null) {
        throw UserNotFoundException();
      } else if (user.emailVerified) {
        throw UserAlreadyVerified;
      }
      await user.sendEmailVerification();
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: 'failed to send Verification Email',
      );
      throw FirebaseAuthExceptionMapper.map(e);
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: 'Unknown  send Verification Email error',
      );
      throw const UnknownAuthException();
    }
  }

  @override
  Future<bool> isEmailVerified() async {
    try {
      final user = _firebaseAuth.currentUser;
      user?.reload();
      if (user!.emailVerified) {
        await _firestore.collection('users').doc(user.uid).update({
          'emailVerified': true,
        });
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: 'failed to send Verification Email',
      );
      throw FirebaseAuthExceptionMapper.map(e);
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: 'Unknown  send Verification Email error',
      );
      throw const UnknownAuthException();
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final List<ConnectivityResult> netStatus = await _connectivity
          .checkConnectivity();
      final isOnline =
          netStatus.contains(ConnectivityResult.mobile) ||
          netStatus.contains(ConnectivityResult.wifi);
      if (!isOnline) {
        throw const NetworkException();
      }

      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const UserNotFoundException();
      }
      await user.reload();
      if (!user.emailVerified) {
        await logout();
        throw const EmailNotVerifiedException();
      }

      return _mapUserModel(user, user.providerData.first.providerId);
    } on FirebaseAuthException catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: 'Get current user failed',
      );
      throw FirebaseAuthExceptionMapper.map(e);
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: 'Unknown get current user error',
      );
      if (e is UserNotFoundFailure ||
          e is EmailNotVerifiedFailure ||
          e is NetworkFailure) {
        rethrow;
      }
      throw const UnknownAuthException();
    }
  }

  @override
  Future<void> reloadUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const UserNotFoundException();
      }
      await user.reload();
    } on FirebaseAuthException catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: 'Reload user failed',
      );
      throw FirebaseAuthExceptionMapper.map(e);
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: 'Unknown reload user error',
      );
      throw const UnknownAuthException();
    }
  }

  @override
  Future<UserModel> updateProfileImage(File imageFile) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) throw const UserNotFoundException();

      // 🔹 Reference to profile image in Storage
      final ref = _firebaseStorage.ref().child(
        'profile_images/${user.uid}.jpg',
      );

      // 🔹 Delete existing file if exists (for Google login or previous uploads)
      try {
        await ref.getMetadata();
        await ref.delete();
            } catch (_) {
        // Ignore if no file exists
      }

      // 🔹 Upload new file
      await ref.putFile(imageFile);
      final downloadUrl = await ref.getDownloadURL();

      XLoggerHelper.debug('Profile image updated: ${user.uid} - $downloadUrl');

      // 🔹 Update Firestore for both Google and email/password users
      await _firestore.collection('users').doc(user.uid).update({
        'photoUrl': downloadUrl,
      });

      // 🔹 Update FirebaseAuth profile (optional, mainly for Google users)
      await user.updatePhotoURL(downloadUrl);
      await user.reload();
      final updatedUser = _firebaseAuth.currentUser!;

      // 🔹 Return updated user model
      return _mapUserModel(
        updatedUser,
        updatedUser.providerData.first.providerId,
      );
    } on FirebaseAuthException catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: 'Update profile image failed',
      );
      throw ApiException(ApiErrorMapper.map(e));
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: 'Unknown update profile image error',
      );
      throw const UnknownAuthException();
    }
  }
}
