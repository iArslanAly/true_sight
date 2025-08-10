import 'package:flutter/material.dart';
import 'package:true_sight/app/app.dart';
import 'package:true_sight/app/providers.dart';

void main() {
  runApp(AppProviders.buildBlocs(const App()));
  WidgetsFlutterBinding.ensureInitialized();
  // Ensure that the app is ready to run before proceeding

}
