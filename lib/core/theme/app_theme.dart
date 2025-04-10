// ignore_for_file: avoid_classes_with_only_static_members
// core/theme/app_theme.dart
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.light.background,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.light.background,
      foregroundColor: AppColors.light.text,
    ),
    textTheme: TextTheme(
      headlineLarge: AppTextStyles.light.headline,
      bodyLarge: AppTextStyles.light.body,
      labelLarge: AppTextStyles.light.button,
      bodySmall: AppTextStyles.light.caption,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          AppColors.light.buttonBackground1,
        ),
        foregroundColor: WidgetStateProperty.all(AppColors.light.buttonText1),
        textStyle: WidgetStateProperty.all(AppTextStyles.light.button),
      ),
    ),
    iconTheme: IconThemeData(color: AppColors.light.favorite),
  );

  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.dark.background,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.dark.background,
      foregroundColor: AppColors.dark.text,
    ),
    textTheme: TextTheme(
      headlineLarge: AppTextStyles.dark.headline,
      bodyLarge: AppTextStyles.dark.body,
      labelLarge: AppTextStyles.dark.button,
      bodySmall: AppTextStyles.dark.caption,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          AppColors.dark.buttonBackground1,
        ),
        foregroundColor: WidgetStateProperty.all(AppColors.dark.buttonText1),
        textStyle: WidgetStateProperty.all(AppTextStyles.dark.button),
      ),
    ),
    iconTheme: IconThemeData(color: AppColors.dark.favorite),
  );
}
