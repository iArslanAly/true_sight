import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:true_sight/app/app.dart';
import 'package:true_sight/app/providers.dart';
import 'package:true_sight/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await init(); // register all dependencies
  runApp(AppProviders.buildBlocs(const App()));
}
