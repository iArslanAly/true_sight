import 'package:true_sight/core/constants/sizes.dart';
import 'package:flutter/material.dart';

class ETextTheme {
  ETextTheme._();

  static const Color lightPrimaryText = Colors.black;
  static const Color lightSecondaryText = Colors.black54;
  static const Color darkPrimaryText = Colors.white;
  static const Color darkSecondaryText = Colors.white54;

  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: TextStyle(
      fontSize: XSizes.d32,
      fontWeight: FontWeight.bold,
      color: lightPrimaryText,
    ),
    headlineMedium: TextStyle(
      fontSize: XSizes.d24,
      fontWeight: FontWeight.w600,
      color: lightPrimaryText,
    ),
    headlineSmall: TextStyle(
      fontSize: XSizes.d20,
      fontWeight: FontWeight.w500,
      color: lightPrimaryText,
    ),
    titleLarge: TextStyle(
      fontSize: XSizes.d18,
      fontWeight: FontWeight.w600,
      color: lightPrimaryText,
    ),
    titleMedium: TextStyle(
      fontSize: XSizes.d16,
      fontWeight: FontWeight.w500,
      color: lightPrimaryText,
    ),
    titleSmall: TextStyle(
      fontSize: XSizes.d14,
      fontWeight: FontWeight.w400,
      color: lightPrimaryText,
    ),
    bodyLarge: TextStyle(
      fontSize: XSizes.d16,
      fontWeight: FontWeight.w500,
      color: lightPrimaryText,
    ),
    bodyMedium: TextStyle(
      fontSize: XSizes.d14,
      fontWeight: FontWeight.normal,
      color: lightPrimaryText,
    ),
    bodySmall: TextStyle(
      fontSize: XSizes.d14,
      fontWeight: FontWeight.w500,
      color: lightPrimaryText,
    ),
    labelLarge: TextStyle(
      fontSize: XSizes.d12,
      fontWeight: FontWeight.normal,
      color: lightPrimaryText,
    ),
    labelMedium: TextStyle(
      fontSize: XSizes.d12,
      fontWeight: FontWeight.normal,
      color: lightSecondaryText,
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    headlineLarge: TextStyle(
      fontSize: XSizes.d32,
      fontWeight: FontWeight.bold,
      color: darkPrimaryText,
    ),
    headlineMedium: TextStyle(
      fontSize: XSizes.d24,
      fontWeight: FontWeight.w600,
      color: darkPrimaryText,
    ),
    headlineSmall: TextStyle(
      fontSize: XSizes.d20,
      fontWeight: FontWeight.w500,
      color: darkPrimaryText,
    ),
    titleLarge: TextStyle(
      fontSize: XSizes.d18,
      fontWeight: FontWeight.w600,
      color: darkPrimaryText,
    ),
    titleMedium: TextStyle(
      fontSize: XSizes.d16,
      fontWeight: FontWeight.w500,
      color: darkPrimaryText,
    ),
    titleSmall: TextStyle(
      fontSize: XSizes.d14,
      fontWeight: FontWeight.w400,
      color: darkPrimaryText,
    ),
    bodyLarge: TextStyle(
      fontSize: XSizes.d16,
      fontWeight: FontWeight.w500,
      color: darkPrimaryText,
    ),
    bodyMedium: TextStyle(
      fontSize: XSizes.d14,
      fontWeight: FontWeight.normal,
      color: darkPrimaryText,
    ),
    bodySmall: TextStyle(
      fontSize: XSizes.d14,
      fontWeight: FontWeight.w500,
      color: darkPrimaryText,
    ),
    labelLarge: TextStyle(
      fontSize: XSizes.d12,
      fontWeight: FontWeight.normal,
      color: darkPrimaryText,
    ),
    labelMedium: TextStyle(
      fontSize: XSizes.d12,
      fontWeight: FontWeight.normal,
      color: darkSecondaryText,
    ),
  );
}
