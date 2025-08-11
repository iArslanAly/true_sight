import 'package:email_otp/email_otp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:true_sight/app/app.dart';
import 'package:true_sight/app/providers.dart';
import 'package:true_sight/service_locator.dart';

void main() async {
  EmailOTP.config(
    appName: 'TrueSight',
    otpType: OTPType.numeric,
    expiry: 30000,
    emailTheme: EmailTheme.v6,
    appEmail: 'iarslanali0@gmail.com',
    otpLength: 4,
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await init(); // register all dependencies
  runApp(AppProviders.buildBlocs(const App()));
}
