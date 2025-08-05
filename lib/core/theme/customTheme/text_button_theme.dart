import 'package:flutter/material.dart';
import 'package:true_sight/core/constants/colors.dart';
import 'package:true_sight/core/constants/sizes.dart';

class ETextButtonTheme {
  ETextButtonTheme._(); // prevent instantiation

  /// Light theme
  static final lightTextButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: XColors.primary,
      textStyle: const TextStyle(
        fontSize: XSizes.fontSizeMd,
        fontWeight: FontWeight.w600,
        color: XColors.black,
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

  /// Dark theme
  static final darkTextButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: XColors.primary,
      textStyle: const TextStyle(
        fontSize: XSizes.fontSizeMd,
        fontWeight: FontWeight.w600,
        color: XColors.white,
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
