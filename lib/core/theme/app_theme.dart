import 'package:fitness_app/core/constants/app_colors.dart';
import 'package:fitness_app/core/constants/app_fonts_family.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      splashColor: AppColors.orange[AppColors.colorCode10],
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.orange[AppColors.colorCode50],
    ),
    scaffoldBackgroundColor: Colors.transparent,
    primaryColor: AppColors.orange,
    secondaryHeaderColor: AppColors.redOrange,
    fontFamily: AppFontsFamily.balooThambi2,
    // fontFamily: AppFontsFamily.supermercadoOne,
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: AppColors.white,
    ),
    textTheme: TextTheme(
      titleLarge: const TextStyle(
        color: AppColors.white,
        fontWeight: FontWeight.w800,
        fontSize: 24,
      ),
      titleMedium: const TextStyle(
        color: AppColors.white,
        fontWeight: FontWeight.w400,
        fontSize: 18,
      ),
      titleSmall: TextStyle(
        color: AppColors.gray[AppColors.colorCode10],
        fontWeight: FontWeight.w400,
        fontSize: 16,
      ),
      displayLarge: const TextStyle(
        color: AppColors.white,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
      labelLarge: const TextStyle(
        color: AppColors.white,
        fontWeight: FontWeight.w800,
        fontSize: 20,
      ),
      labelMedium: const TextStyle(
        color: AppColors.white,
        fontWeight: FontWeight.w800,
        fontSize: 14,
      ),
      labelSmall: const TextStyle(
        color: AppColors.white,
        fontWeight: FontWeight.w400,
        fontSize: 14,
      ),
      displayMedium: const TextStyle(
        color: AppColors.white,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      headlineLarge: const TextStyle(
        color: AppColors.orange,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
      headlineMedium: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.white,
      ),
      bodyLarge: const TextStyle(
        color: AppColors.white,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      bodyMedium: TextStyle(
        color: AppColors.gray[AppColors.colorCode10],
        fontWeight: FontWeight.w700,
        fontSize: 12,
      ),
      bodySmall: TextStyle(
        color: AppColors.gray[AppColors.colorCode10],
        fontWeight: FontWeight.w400,
        fontSize: 12,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(AppColors.orange),
        foregroundColor: WidgetStateProperty.all(AppColors.white),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        elevation: WidgetStateProperty.all(0),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 15,
            color: AppColors.white,
          ),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.all(14),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
        foregroundColor: WidgetStateProperty.all(AppColors.white),
        side: WidgetStateProperty.all(
          const BorderSide(
            color: AppColors.orange,
            width: 1,
          ),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        elevation: WidgetStateProperty.all(0),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 15,
            color: AppColors.white,
          ),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.all(14),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      errorStyle: const TextStyle(color: AppColors.red, fontSize: 12),
      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
      iconColor: AppColors.lightPink,
      hintStyle: TextStyle(
        color: AppColors.gray[AppColors.colorCode10],
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      prefixIconColor: AppColors.white,
      suffixIconColor: AppColors.white,
      labelStyle: TextStyle(
        fontSize: 12,
        color: AppColors.gray[AppColors.colorCode10],
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10000),
        borderSide: const BorderSide(
          width: 1,
          color: AppColors.white,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10000),
        borderSide: const BorderSide(
          width: 1,
          color: AppColors.white,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10000),
        borderSide: const BorderSide(
          width: 1.5,
          color: AppColors.white,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10000),
        borderSide: const BorderSide(
          width: 1,
          color: AppColors.red,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10000),
        borderSide: const BorderSide(
          width: 1,
          color: AppColors.red,
        ),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        foregroundColor: WidgetStateProperty.all(AppColors.orange),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: AppColors.orange,
          ),
        ),
      ),
    ),
    radioTheme: const RadioThemeData(
      fillColor: WidgetStatePropertyAll((AppColors.orange)),
      overlayColor: WidgetStatePropertyAll(AppColors.orange),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      backgroundColor: AppColors.shearGray,
      dragHandleSize: Size(80, 4),
      dragHandleColor: AppColors.black,
      showDragHandle: true,
      elevation: 0,
    ),
  );
}
