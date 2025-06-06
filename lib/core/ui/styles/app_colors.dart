import 'dart:ui';

class AppColors {
  static AppColors? _instance;
  AppColors._();

  static AppColors get i {
    _instance ??= AppColors._();
    return _instance!;
  }

  Color get containerColor => const Color(0xFFF2F2F5);
  Color get primaryColor => const Color(0xFF09A780);
  Color get dividerColor => const Color(0xFFDDDDDE);
  Color get dividerColorDarkMode => const Color(0xFF414040);
  Color get errorColor => const Color(0xFFFF3B3B);
  Color get successColor => const Color(0xFF06C270);
  Color get warningColor => const Color(0xFFFFCC00);
  Color get infoColor => const Color(0xFF0063F7);
}
