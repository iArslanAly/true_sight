import 'package:flutter/material.dart';

class XColors {
  XColors._();

  // App Basic Colors
  static const Color tertiary = Color(0xFF3B3833);
  static const Color secondary = Color(0XFFFFFFFF);
  static const Color primary = Color(0xFFFF6565);
  static const Color amber = Color.fromARGB(255, 255, 191, 0);
  // Text Colors
  static const Color textPrimary = Color(0XFFFFFFFF);
  static const Color textSecondary = Color.fromARGB(195, 255, 255, 255);

  // Background Colors
  static const Color light = Color(0xFFF6F6F6);
  static const Color dark = Color.fromARGB(255, 0, 0, 0);
  static const Color primaryBackground = Color(0xFFF3F5FF);
  static const Color transparent = Colors.transparent;

  //    Gradient Colors
  // static const Gradient linerGradient = LinearGradient(
  //   begin: Alignment(0.0, 0.0), end: Alignment(0.707, -0.707),
  //   colors: [
  //     Color(0xffff9a9e),
  //     Color(0xfffad0c4),
  //     Color(0xfffad0c4),
  //   ]
  // );

  // Background Container Colors
  static const Color lightContainer = Color(0xFFF6F6F6);
  static const Color darkContainer = Color(0x1AFFFFFF); // 0x1A = 10% opacity

  // Button Colers
  // Button Colers
  static const Color buttonPrimary = Color(0xFFFF6565);
  static const Color buttonSecondary = Color(0xFF6C757D);
  static const Color buttonDisabled = Color(0xFFC4C4C4);

  // Border Colors
  static const Color borderPrimary = Color(0xFFD9D9D9);
  static const Color borderSecondary = Color(0x00ffe666);

  // Error and Validation Colors
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0XFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0xFF1976D2);

  // Neutral Shades
  static const Color black = Color(0xFF232323);
  static const Color darkerGrey = Color(0xFF535353);
  static const Color darkGrey = Color(0xFF939393);
  static const Color grey = Color(0xFFE0E0E0);
  static const Color softGrey = Color(0xFFF4F4F4);
  static const Color lightGrey = Color(0xFFF9F9F9);
  static const Color white = Color(0xFFFFFFFF);
}
