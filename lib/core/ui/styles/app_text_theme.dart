import 'package:flutter/material.dart';

class AppTextTheme {
  static AppTextTheme? _instance;
  AppTextTheme._();

  static AppTextTheme get i {
    _instance ??= AppTextTheme._();
    return _instance!;
  }

  TextTheme get textTheme => const TextTheme(
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          fontFamily: 'Poppins',
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
        bodyLarge: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
        bodyMedium: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
        bodySmall: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w400,
          fontFamily: 'Inter',
        ),
      );
}
