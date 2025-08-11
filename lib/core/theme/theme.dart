import 'package:google_fonts/google_fonts.dart';
import 'package:true_sight/core/constants/colors.dart';
import 'package:true_sight/core/theme/customTheme/appbar_theme.dart';
import 'package:true_sight/core/theme/customTheme/bottom_sheet_theme.dart';
import 'package:true_sight/core/theme/customTheme/checkbox_theme.dart';
import 'package:true_sight/core/theme/customTheme/chip_theme.dart';
import 'package:true_sight/core/theme/customTheme/elevated_button_theme.dart';
import 'package:true_sight/core/theme/customTheme/navigation_bar_theme.dart';
import 'package:true_sight/core/theme/customTheme/outlines_button_theme.dart';
import 'package:true_sight/core/theme/customTheme/text_button_theme.dart';
import 'package:true_sight/core/theme/customTheme/text_field_theme.dart';
import 'package:true_sight/core/theme/customTheme/text_theme.dart';
import 'package:flutter/material.dart';

class TAppTheme {
  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: XColors.primary,
    scaffoldBackgroundColor: XColors.white,
    fontFamily: GoogleFonts.poppins().fontFamily,

    // 🔧 Fix: Transparent surface tint to prevent pink overlay
    colorScheme: ColorScheme.fromSeed(
      seedColor: XColors.primary,
      brightness: Brightness.light,
    ).copyWith(surfaceTint: XColors.transparent),

    // Custom themes
    chipTheme: EChipTheme.lightChipTheme,
    textTheme: ETextTheme.lightTextTheme,
    appBarTheme: EAppBarTheme.lightAppBarTheme,
    checkboxTheme: ECheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: EBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: EElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: EOutlinedButtonTheme.lightOutlinedButtonTheme,
    textButtonTheme: ETextButtonTheme.lightTextButtonTheme,
    inputDecorationTheme: ETextFormFieldTheme.lightInputDecorationTheme,
    navigationBarTheme: ENavigationBarTheme.lightNavigationBarTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: XColors.primary,
    scaffoldBackgroundColor: Colors.black,
    fontFamily: GoogleFonts.poppins().fontFamily,

    // Optional: Surface tint override for dark mode too
    colorScheme: ColorScheme.fromSeed(
      seedColor: XColors.primary,
      brightness: Brightness.dark,
    ).copyWith(surfaceTint: Colors.transparent),

    // Custom themes
    chipTheme: EChipTheme.darkChipTheme,
    textTheme: ETextTheme.darkTextTheme,
    appBarTheme: EAppBarTheme.darkAppBarTheme,
    checkboxTheme: ECheckboxTheme.darkCheckboxTheme,
    bottomSheetTheme: EBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: EElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: EOutlinedButtonTheme.darkOutlinedButtonTheme,
    textButtonTheme: ETextButtonTheme.darkTextButtonTheme,
    inputDecorationTheme: ETextFormFieldTheme.darkInputDecorationTheme,
    navigationBarTheme: ENavigationBarTheme.darkNavigationBarTheme,
  );
}
