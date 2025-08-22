import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:true_sight/app/app.dart';
import 'package:true_sight/app/providers.dart';
import 'package:true_sight/core/localStorage/sotage_helper.dart';
import 'package:true_sight/core/services/otp_config_service.dart';
import 'package:true_sight/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  OTPConfigService.init(); // Configure OTP before app starts
  await init(); // register all dependencies
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  /// Check first launch
  final isFirstLaunch = await StorageHelper.isFirstLaunch();

  if (isFirstLaunch) {
    /// Clear all local data and sign out Firebase
    await StorageHelper.clearAll();
    await FirebaseAuth.instance.signOut();

    /// Mark that first launch has been handled
    await StorageHelper.markFirstLaunchDone();

    /// Configure Dio clients
  }
  runApp(AppProviders.buildBlocs(const App()));
}
      