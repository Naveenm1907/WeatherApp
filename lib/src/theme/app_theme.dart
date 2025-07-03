import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  AppTheme._();
  static const Color primaryLight = Color(0xFF039BE5); // Light Blue 600
  static const Color primaryDark = Color(0xFF0277BD); // Light Blue 800
  static const Color accentLight = Color(0xFFFFD54F); // Amber 300
  static const Color accentDark = Color(0xFFFFCA28); // Amber 400
  static const Color errorColor = Color(0xFFE53935);
  static const Color successColor = Color(0xFF43A047);
  static const LinearGradient clearDayGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF2196F3), // Blue 500
      Color(0xFF03A9F4), // Light Blue 500
    ],
  );

  static const LinearGradient clearNightGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF1A237E), // Indigo 900
      Color(0xFF283593), // Indigo 800
    ],
  );

  static const LinearGradient rainyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF546E7A), // Blue Grey 600
      Color(0xFF607D8B), // Blue Grey 500
    ],
  );

  static const LinearGradient cloudyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF42A5F5), // Blue 400
      Color(0xFF64B5F6), // Blue 300
    ],
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: primaryLight,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryLight,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Colors.white,
      fontFamily: 'Montserrat',
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryLight,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      cardTheme: CardTheme(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentLight,
          foregroundColor: Colors.black87,
          elevation: 4,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          fontSize: 32,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          fontSize: 28,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.normal,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.normal,
          fontSize: 14,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: primaryDark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryDark,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      fontFamily: 'Montserrat',
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryDark,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      cardTheme: CardTheme(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentDark,
          foregroundColor: Colors.black87,
          elevation: 4,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[900],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          fontSize: 32,
          color: Colors.white,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          fontSize: 28,
          color: Colors.white,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: Colors.white,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: Colors.white,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.normal,
          fontSize: 16,
          color: Colors.white,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.normal,
          fontSize: 14,
          color: Colors.white,
        ),
      ),
    );
  }
} 