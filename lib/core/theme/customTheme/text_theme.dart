import 'package:true_sight/core/constants/sizes.dart';
import 'package:flutter/material.dart';

class ETextTheme {
  ETextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(
      fontSize: XSizes.d32,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    headlineMedium: const TextStyle().copyWith(
      fontSize: XSizes.d24,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),

    headlineSmall: const TextStyle().copyWith(
      fontSize: XSizes.d20,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    titleLarge: const TextStyle().copyWith(
      fontSize: XSizes.d18,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    titleMedium: const TextStyle().copyWith(
      fontSize: XSizes.d16,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    titleSmall: const TextStyle().copyWith(
      fontSize: XSizes.d14,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    bodyLarge: const TextStyle().copyWith(
      fontSize: XSizes.d16,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    bodyMedium: const TextStyle().copyWith(
      fontSize: XSizes.d14,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    bodySmall: const TextStyle().copyWith(
      fontSize: XSizes.d14,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    labelLarge: const TextStyle().copyWith(
      fontSize: XSizes.d12,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    labelMedium: const TextStyle().copyWith(
      fontSize: XSizes.d12,
      fontWeight: FontWeight.normal,
      color: Colors.black54,
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(
      fontSize: XSizes.d32,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headlineMedium: const TextStyle().copyWith(
      fontSize: XSizes.d24,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    headlineSmall: const TextStyle().copyWith(
      fontSize: XSizes.d18,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
    titleLarge: const TextStyle().copyWith(
      fontSize: XSizes.d16,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    titleMedium: const TextStyle().copyWith(
      fontSize: XSizes.d16,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    titleSmall: const TextStyle().copyWith(
      fontSize: XSizes.d16,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
    bodyLarge: const TextStyle().copyWith(
      fontSize: XSizes.d14,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    bodyMedium: const TextStyle().copyWith(
      fontSize: XSizes.d14,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
    bodySmall: const TextStyle().copyWith(
      fontSize: XSizes.d14,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    labelLarge: const TextStyle().copyWith(
      fontSize: XSizes.d12,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
    labelMedium: const TextStyle().copyWith(
      fontSize: XSizes.d12,
      fontWeight: FontWeight.normal,
      color: Colors.white54,
    ),
  );
}
