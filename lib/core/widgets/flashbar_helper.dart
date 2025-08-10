import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:true_sight/core/constants/colors.dart';

class FlushbarHelper {
  static void showInfo(
    BuildContext context, {
    String? title,
    required String message,
    Duration duration = const Duration(seconds: 6),
  }) {
    Flushbar(
      titleText: title != null
          ? Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: XColors.white,
                fontSize: 16,
              ),
            )
          : null,
      message: message,
      duration: duration,
      backgroundColor: Colors.blue.shade600,
      flushbarPosition: FlushbarPosition.TOP,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      icon: const Icon(Icons.info, color: XColors.white),
    ).show(context);
  }

  static void showSuccess(
    BuildContext context, {
    String? title,
    required String message,
    Duration duration = const Duration(seconds: 6),
  }) {
    Flushbar(
      titleText: title != null
          ? Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: XColors.white,
                fontSize: 16,
              ),
            )
          : null,
      message: message,
      duration: duration,
      backgroundColor: XColors.black,
      flushbarPosition: FlushbarPosition.TOP,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      icon: const Icon(Icons.check_circle, color: XColors.white),
    ).show(context);
  }

  static void showError(
    BuildContext context, {
    String? title,
    required String message,
    Duration duration = const Duration(seconds: 6),
  }) {
    Flushbar(
      titleText: title != null
          ? Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: XColors.white,
                fontSize: 16,
              ),
            )
          : null,
      message: message,
      duration: duration,
      backgroundColor: XColors.error,
      flushbarPosition: FlushbarPosition.TOP,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      icon: const Icon(Icons.error, color: XColors.white),
    ).show(context);
  }
}
