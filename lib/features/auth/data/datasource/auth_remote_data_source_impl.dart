import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:true_sight/core/error/failure.dart';
import 'package:true_sight/core/error/firebase_auth_exception_handler.dart';
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

  AuthRemoteDataSourceImpl({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
    required GoogleSignIn googleSignIn,
    required Connectivity connectivity,
  }) : _firebaseAuth = firebaseAuth,
       _firestore = firestore,
       _googleSignIn = googleSignIn,
       _connectivity = connectivity;

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
        throw const UserNotFoundFailure();
      } else {
        await user.reload();

        final refreshedUser = _firebaseAuth.currentUser!;
        XLoggerHelper.debug('User verified? ${refreshedUser.emailVerified}');
        if (!refreshedUser.emailVerified) {
          XLoggerHelper.debug('User email not verified - throwing error');
          throw EmailNotVerifiedFailure();
        }
        await _createUserDoc(user, 'email');
        return _mapUserModel(user, 'email');
      }
    } on FirebaseAuthException catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s, reason: 'Login failed');
      throw FirebaseAuthExceptionHandler.handle(e);
    } on TimeoutException catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: 'Signing timed out',
      );
      throw const SigninTimeoutFailure();
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: 'Unknown signing error',
      );
      if (e is EmailNotVerifiedFailure || e is UserNotFoundFailure) {
        rethrow; // propagate them upwards
      }
      throw const UnknownAuthFailure();
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
      throw FirebaseAuthExceptionHandler.handle(e);
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
      throw const UnknownAuthFailure();
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
      throw FirebaseAuthExceptionHandler.handle(e);
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
    try {
      // 1️⃣ Get Firebase ID Token
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw const UnknownAuthFailure();

      const String baseUrl = 'http://localhost:300';

      final response = await http.post(
        Uri.parse('$baseUrl/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'newPassword': newPassword}),
      );

      if (response.statusCode == 200) return;

      final body = jsonDecode(response.body);
      final message = body['message'] ?? 'Password update failed';

      if (response.statusCode == 400) {
        throw UpdatePasswordFailure(message);
      } else if (response.statusCode == 404) {
        throw UpdatePasswordFailure('Email not found.');
      } else if (response.statusCode >= 500) {
        throw ServerFailure(message: 'Server error: $message');
      } else {
        throw UpdatePasswordFailure(message);
      }
    } on SocketException {
      throw const ServerUnreachableFailure();
    } on FormatException {
      throw ServerFailure(message: 'Invalid server response.');
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: 'Password reset API failed',
      );
      if (e is UpdatePasswordFailure ||
          e is ServerFailure ||
          e is ServerUnreachableFailure ||
          e is TimeoutException) {
        rethrow; // propagate them upwards
      }
      throw const UnknownAuthFailure();
    }
  }

  @override
  Future<void> sendOtp(String email) async {
    try {
      XLoggerHelper.debug("[AuthRemoteDataSourceImpl] : Sending OTP to $email");

      // Replace placeholders in template
      final templateWithTime = OTPConfigService.otpTemplate
          .replaceAll('{{year}}', currentYear())
          .replaceAll('{{dateTime}}', formattedDateTime());

      // Apply the updated template before sending
      EmailOTP.setTemplate(template: templateWithTime);

      final isSent = await EmailOTP.sendOTP(email: email);
      if (!isSent) {
        throw OtpSendFailure();
      }

      XLoggerHelper.debug("[AuthRemoteDataSourceImpl] : ✅ OTP sent to $email");
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

      throw const UnknownAuthFailure();
    }
  }

  @override
  Future<void> verifyOtp(String otp) async {
    try {
      XLoggerHelper.debug("[AuthRemoteDataSourceImpl] : Verifying OTP: $otp");

      // Static call — returns bool
      final isValid = EmailOTP.verifyOTP(otp: otp);
      if (!isValid) {
        throw InvalidOtpFailure();
      }

      XLoggerHelper.debug(
        "[AuthRemoteDataSourceImpl] : ✅ OTP verified successfully! $isValid",
      );
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: 'Unexpected OTP verify error',
      );
      if (e is InvalidOtpFailure) {
        rethrow; // propagate InvalidOtpFailure upwards
      }
      throw const UnknownAuthFailure();
    }
  }

  @override
  Future<void> resendVerificationEmail() async {
    try {
      final user = _firebaseAuth.currentUser;
      await user?.reload();
      if (user == null) {
        throw UserNotFoundFailure();
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
      throw FirebaseAuthExceptionHandler.handle(e);
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: 'Unknown  send Verification Email error',
      );
      throw const UnknownAuthFailure();
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
      throw FirebaseAuthExceptionHandler.handle(e);
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: 'Unknown  send Verification Email error',
      );
      throw const UnknownAuthFailure();
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
        throw const NetworkFailure();
      }

      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const UserNotFoundFailure();
      }
      await user.reload();
      if (!user.emailVerified) {
        await logout();
        throw const EmailNotVerifiedFailure();
      }

      return _mapUserModel(user, 'email');
    } on FirebaseAuthException catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: 'Get current user failed',
      );
      throw FirebaseAuthExceptionHandler.handle(e);
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
      throw const UnknownAuthFailure();
    }
  }

  @override
  Future<void> reloadUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw const UserNotFoundFailure();
      }
      await user.reload();
    } on FirebaseAuthException catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: 'Reload user failed',
      );
      throw FirebaseAuthExceptionHandler.handle(e);
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(
        e,
        s,
        reason: 'Unknown reload user error',
      );
      throw const UnknownAuthFailure();
    }
  }
}
