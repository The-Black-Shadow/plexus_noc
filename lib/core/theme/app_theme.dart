import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData.light(useMaterial3: true).copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2563EB), 
        brightness: Brightness.light,
      ).copyWith(
        surface: const Color(0xFFF8FAFC), 
        error: const Color(0xFFEF4444), 
        tertiary: const Color(0xFF10B981), 
      ),
      scaffoldBackgroundColor: const Color(0xFFF1F5F9), 
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData.dark(useMaterial3: true).copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF3B82F6), 
        brightness: Brightness.dark,
      ).copyWith(
        surface: const Color(0xFF1E293B), 
        error: const Color(0xFFF87171), 
        tertiary: const Color(0xFF34D399), 
      ),
      scaffoldBackgroundColor: const Color(0xFF0F172A), 
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      cardColor: const Color(0xFF1E293B), 
      cardTheme: CardThemeData(
        elevation: 0,
        color: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Color(0xFF334155), width: 1), 
        ),
      ),
    );
  }
}
