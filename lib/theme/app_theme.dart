import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryYellow = Color(0xFFFFD600);
  static const Color primaryBlack = Color(0xFF1A1A1A);
  static const Color surfaceBlack = Color(0xFF2D2D2D);
  static const Color darkGray = Color(0xFF3D3D3D);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: primaryYellow,
        secondary: primaryYellow.withValues(alpha: 0.7),
        surface: surfaceBlack,
      ),
      scaffoldBackgroundColor: primaryBlack,
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceBlack,
        foregroundColor: primaryYellow,
        elevation: 0,
        centerTitle: true,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceBlack,
        selectedItemColor: primaryYellow,
        unselectedItemColor: Colors.grey,
      ),
      cardTheme: CardThemeData(
        color: surfaceBlack,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryYellow,
        foregroundColor: primaryBlack,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryYellow,
          foregroundColor: primaryBlack,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryYellow, width: 2),
        ),
      ),
    );
  }
}
