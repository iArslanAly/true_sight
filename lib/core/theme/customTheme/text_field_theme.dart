import 'package:true_sight/core/constants/colors.dart';
import 'package:true_sight/core/constants/sizes.dart';
import 'package:flutter/material.dart';

class ETextFormFieldTheme {
  ETextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: XColors.grey,
    suffixIconColor: XColors.grey,
    // constraints: const BoxConstraints.expand(height: 14.inputFieldHeight),
    labelStyle: const TextStyle(
      fontSize: XSizes.fontSizeSm,
      color: XColors.black,
    ),
    hintStyle: const TextStyle(
      fontSize: XSizes.fontSizeSm,
      color: XColors.black,
    ),
    errorStyle: const TextStyle(fontStyle: FontStyle.normal),
    floatingLabelStyle: const TextStyle(
      color: XColors.black,
    ).copyWith(color: XColors.black.withValues(alpha: 0.8)),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(XSizes.d14),
      borderSide: const BorderSide(width: 1, color: XColors.grey),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(XSizes.d14),
      borderSide: const BorderSide(width: 1, color: XColors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(XSizes.d14),
      borderSide: const BorderSide(width: 1, color: Colors.black12),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(XSizes.d14),
      borderSide: const BorderSide(width: 1, color: Colors.red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(XSizes.d14),
      borderSide: const BorderSide(width: 2, color: Colors.orange),
    ),
  );
  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 2,
    prefixIconColor: XColors.grey,
    suffixIconColor: XColors.grey,
    // constraints: const BoxConstraints.expand(height: 14.inputFieldHeight),
    labelStyle: const TextStyle().copyWith(
      fontSize: XSizes.fontSizeSm,
      color: XColors.white,
    ),
    hintStyle: const TextStyle().copyWith(
      fontSize: XSizes.fontSizeSm,
      color: XColors.white,
    ),
    floatingLabelStyle: const TextStyle().copyWith(
      color: XColors.white.withValues(alpha: 0.8),
    ),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(XSizes.d14),
      borderSide: const BorderSide(width: 1, color: XColors.grey),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(XSizes.d14),
      borderSide: const BorderSide(width: 1, color: XColors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(XSizes.d14),
      borderSide: const BorderSide(width: 1, color: XColors.white),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(XSizes.d14),
      borderSide: const BorderSide(width: 1, color: XColors.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(XSizes.d14),
      borderSide: const BorderSide(width: 2, color: Colors.orange),
    ),
  ); // InputDecorationTheme
}
