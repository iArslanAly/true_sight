import 'package:true_sight/core/constants/colors.dart';
import 'package:true_sight/core/constants/sizes.dart';
import 'package:flutter/material.dart';

class EChipTheme {
  EChipTheme._();
  static ChipThemeData lightChipTheme = ChipThemeData(
    disabledColor: XColors.grey.withValues(alpha: XSizes.pointZeroFour),
    labelStyle: const TextStyle(color: XColors.black),
    selectedColor: XColors.primary,
    padding: const EdgeInsets.symmetric(
      horizontal: XSizes.d12,
      vertical: XSizes.d12,
    ),
    checkmarkColor: XColors.white,
  );
  static ChipThemeData darkChipTheme = const ChipThemeData(
    disabledColor: XColors.grey,
    labelStyle: TextStyle(color: XColors.white),
    selectedColor: XColors.primary,
    padding: EdgeInsets.symmetric(
      horizontal: XSizes.d12,
      vertical: XSizes.d12,
    ),
    checkmarkColor: XColors.white,
  );
}
