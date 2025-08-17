import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:true_sight/core/theme/theme.dart';

enum AppThemeMode { light, dark }

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(TAppTheme.lightTheme);

  void toggleTheme() {
    emit(
      state.brightness == Brightness.light
          ? TAppTheme.darkTheme
          : TAppTheme.lightTheme,
    );
  }

  void setTheme(AppThemeMode mode) {
    emit(
      mode == AppThemeMode.light ? TAppTheme.lightTheme : TAppTheme.darkTheme,
    );
  }
}
