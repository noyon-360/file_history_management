import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get dark => ThemeData(
    scaffoldBackgroundColor: AppColors.primaryBlack,
    fontFamily: 'Manrope',
    colorScheme: ColorScheme.dark(primary: AppColors.primaryWhite),

    textTheme:
        const TextTheme(
          displayLarge: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.primaryWhite,
          ),
          displayMedium: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.primaryWhite,
          ),
          displaySmall: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.primaryWhite,
          ),
          headlineLarge: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 32,
            color: AppColors.primaryWhite,
          ),
          headlineMedium: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 28,
            color: AppColors.primaryWhite,
          ),
          headlineSmall: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: AppColors.primaryWhite,
          ),
          titleLarge: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: AppColors.primaryWhite,
          ),
          titleMedium: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: AppColors.primaryWhite,
          ),
          titleSmall: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: AppColors.primaryWhite,
          ),
          bodyLarge: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: AppColors.primaryWhite,
          ),
          bodyMedium: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: AppColors.primaryWhite,
          ),
          bodySmall: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: AppColors.primaryWhite,
          ),
          labelLarge: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: AppColors.primaryWhite,
          ),
          labelMedium: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
            color: AppColors.primaryWhite,
          ),
          labelSmall: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 11,
            color: AppColors.primaryWhite,
          ),
        ).apply(
          bodyColor: AppColors.primaryWhite,
          displayColor: AppColors.primaryWhite,
        ),

    appBarTheme: AppBarThemeData(
      backgroundColor: AppColors.primaryBlack,
      titleTextStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
      centerTitle: false,
    ),
  );
}
