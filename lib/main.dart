import 'package:flutter/material.dart';
import 'package:true_sight/app/app.dart';
import 'package:true_sight/app/providers.dart';

void main() {
  runApp(AppProviders.buildBlocs(const App()));
}
