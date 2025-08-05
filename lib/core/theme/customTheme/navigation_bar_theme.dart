import 'package:true_sight/core/constants/colors.dart';
import 'package:true_sight/core/constants/sizes.dart';
import 'package:flutter/material.dart';

class ENavigationBarTheme {
  ENavigationBarTheme._();

  static final NavigationBarThemeData lightNavigationBarTheme =
      NavigationBarThemeData(
        backgroundColor: XColors.white,
        indicatorColor: XColors.transparent, // optional to avoid overlay tint

        iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: XColors.primary);
          }
          return const IconThemeData(color: XColors.darkGrey);
        }),

        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: XSizes.fontSizeSm,
              fontWeight: FontWeight.w600,
              color: XColors.primary,
            );
          }
          return const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: XColors.grey,
          );
        }),
      );

  static final NavigationBarThemeData darkNavigationBarTheme =
      NavigationBarThemeData(
        backgroundColor: XColors.black,
        indicatorColor: XColors.transparent,

        iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: XColors.primary);
          }
          return const IconThemeData(color: Colors.grey);
        }),

        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: XSizes.fontSizeSm,
              fontWeight: FontWeight.w600,
              color: XColors.primary,
            );
          }
          return const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          );
        }),
      );
}
