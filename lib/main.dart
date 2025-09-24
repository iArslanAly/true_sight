import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:true_sight/app/app.dart';
import 'package:true_sight/app/providers.dart';
import 'package:true_sight/core/http/dio_clients.dart';
import 'package:true_sight/core/localStorage/sotage_helper.dart';
import 'package:true_sight/core/services/otp_config_service.dart';
import 'package:true_sight/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  OTPConfigService.init();

  // ✅ Load environment variables first
  await dotenv.load(fileName: ".env");
  DioClient.instance.configForRealityDefender();

  // Register dependencies after env is ready
  await init();

  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  final isFirstLaunch = await StorageHelper.isFirstLaunch();
  if (isFirstLaunch) {
    await StorageHelper.clearAll();
    await FirebaseAuth.instance.signOut();
    await StorageHelper.markFirstLaunchDone();
  }

  runApp(AppProviders.buildBlocs(const App()));
}
