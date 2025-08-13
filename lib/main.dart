import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:true_sight/app/app.dart';
import 'package:true_sight/app/providers.dart';
import 'package:true_sight/core/services/otp_config_service.dart';
import 'package:true_sight/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  OTPConfigService.init(); // ✅ Configure OTP before app starts
  await init(); // register all dependencies
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  runApp(AppProviders.buildBlocs(const App()));
}
