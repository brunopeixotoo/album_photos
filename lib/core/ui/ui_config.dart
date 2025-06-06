import 'package:flutter/material.dart';
import 'package:photo/core/ui/styles/styles.dart';

class UiConfig {
  UiConfig._();

  static String get title => 'Photo Album App';

  static ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Poppins',
        useMaterial3: true,
        dividerColor: AppColors.i.dividerColor,
        textTheme: AppTextTheme.i.textTheme,
        primaryColor: AppColors.i.primaryColor,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: AppColors.i.primaryColor,
          primary: AppColors.i.primaryColor,
          error: AppColors.i.errorColor,
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Poppins',
        dividerColor: AppColors.i.dividerColorDarkMode,
        useMaterial3: true,
        textTheme: AppTextTheme.i.textTheme,
        primaryColor: AppColors.i.primaryColor,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: AppColors.i.primaryColor,
          primary: AppColors.i.primaryColor,
          error: AppColors.i.errorColor,
        ),
      );
}
