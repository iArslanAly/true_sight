import 'package:true_sight/core/constants/colors.dart';
import 'package:true_sight/core/constants/sizes.dart';
import 'package:flutter/material.dart';


class EAppBarTheme {
  EAppBarTheme._();
  static const lightAppBarTheme = AppBarTheme(
    elevation: XSizes.d0,
    centerTitle: false,
    scrolledUnderElevation: XSizes.d0,
    backgroundColor: XColors.transparent,
    surfaceTintColor: XColors.transparent,
    iconTheme: IconThemeData(color: XColors.black, size: XSizes.d24),
    actionsIconTheme: IconThemeData(color: XColors.black, size: XSizes.d24),
    titleTextStyle: TextStyle(
      fontSize: XSizes.d18,
      fontWeight: FontWeight.w600,
      color: XColors.black,
    ),
  ); // AppBarTheme
  static const darkAppBarTheme = AppBarTheme(
    elevation: XSizes.d0,
    centerTitle: false,
    toolbarHeight: XSizes.d10,
    scrolledUnderElevation: XSizes.d0,
    backgroundColor: XColors.transparent,
    surfaceTintColor: XColors.transparent,
    iconTheme: IconThemeData(color: XColors.black, size: XSizes.d24),
    actionsIconTheme: IconThemeData(color: XColors.white, size: XSizes.d24),
    titleTextStyle: TextStyle(
      fontSize: XSizes.d18,
      fontWeight: FontWeight.w600,
      color: XColors.white,
    ),
  ); // AppBarTheme
}
