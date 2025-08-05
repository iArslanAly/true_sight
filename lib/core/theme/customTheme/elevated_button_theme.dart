import 'package:true_sight/core/constants/colors.dart';
import 'package:true_sight/core/constants/sizes.dart';
import 'package:flutter/material.dart';

class EElevatedButtonTheme {
  EElevatedButtonTheme._();

  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: XSizes.d0,
      backgroundColor: XColors.secondary,
      foregroundColor: XColors.white,
      disabledForegroundColor: XColors.darkGrey,
      disabledBackgroundColor: XColors.grey,
      side: BorderSide(color: XColors.primary),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(XSizes.d12),
      ),
      padding: const EdgeInsets.symmetric(vertical: XSizes.d18),
      textStyle: const TextStyle(
        fontSize: XSizes.fontSizeMd,
        color: XColors.white,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: XSizes.d0,
      backgroundColor: XColors.primary,
      foregroundColor: XColors.black,
      disabledForegroundColor: XColors.darkGrey,
      disabledBackgroundColor: XColors.grey,
      side: BorderSide(color: XColors.primary),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(XSizes.d12),
      ),
      padding: const EdgeInsets.symmetric(vertical: XSizes.d18),
      textStyle: const TextStyle(
        fontSize: XSizes.fontSizeMd,
        color: XColors.white,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
