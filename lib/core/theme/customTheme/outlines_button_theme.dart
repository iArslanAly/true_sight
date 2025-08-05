import 'package:true_sight/core/constants/colors.dart';
import 'package:true_sight/core/constants/sizes.dart';
import 'package:flutter/material.dart';

class EOutlinedButtonTheme {
  EOutlinedButtonTheme._(); //To avoid creating instances
  /* -- Light Theme -- */
  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: Colors.black,
      side: const BorderSide(color: XColors.primary),
      textStyle: const TextStyle(
        fontSize: XSizes.fontSizeMd,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: XSizes.d16,
        horizontal: XSizes.d20,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(XSizes.d14),
      ),
    ),
  );
  /* -- Dark Theme -- */
  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.white,
      side: const BorderSide(color: XColors.primary),
      textStyle: const TextStyle(
        fontSize: XSizes.fontSizeMd,
        color: XColors.white,
        fontWeight: FontWeight.w600,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: XSizes.d16,
        horizontal: XSizes.d20,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(XSizes.d14),
      ),
    ),
  );
}
