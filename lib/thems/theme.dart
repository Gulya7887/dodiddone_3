import 'package:flutter/material.dart';


class DoDidDoneTheme {
  static ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    primaryColor: const Color(0xFFD87AEA),
    hintColor: const Color(0xFFFFD186),
    brightness: Brightness.light,
    fontFamily: 'Roboto',
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      displayMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.black,
      ),
      headlineMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2276FD), // New color for headlines
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: Color(0xFFB8B8B8), // New color for bodySmall
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor   : Colors.white, // Changed text color
        backgroundColor: const Color(0xFF33A0FB), // Changed background color
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white, // White text for buttons
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        fixedSize: const Size(double.infinity, 48), // Fixed height
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(


      hintStyle: const TextStyle(
        color: Color(0xFFB8B8B8), // Hint text color
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  );


  static ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.blue,
    primaryColor: const Color(0xFFD87AEA),
    hintColor: const Color(0xFFFFD186),
    brightness: Brightness.dark,
    fontFamily: 'Roboto',
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      displayMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.white,
      ),
      headlineMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2276FD), // New color for headlines
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: Color(0xFFB8B8B8), // New color for bodySmall
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF33A0FB), // Changed background color
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white, // White text for buttons
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        fixedSize: const Size(double.infinity, 48), // Fixed height
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      // hintStyle: 'Пароль', // Removed
      hintStyle: const TextStyle(
        color: Color(0xFFB8B8B8), // Hint text color
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
