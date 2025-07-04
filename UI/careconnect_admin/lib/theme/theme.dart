import 'package:careconnect_admin/theme/app_colors.dart';
import 'package:careconnect_admin/theme/app_colors_extension.dart';
import 'package:flutter/material.dart';

final ThemeData myTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryMain,
    brightness: Brightness.light,
    secondary: secondaryColor,
  ),
  extensions: const [
    AppColors(
      primaryLight: primaryLight,
      primaryDark: primaryDark,
      accent: accentColor,
    ),
  ],
);

// final myTheme = ThemeData(
//   useMaterial3: true,
//   colorScheme: ColorScheme(
//     brightness: Brightness.light,
//     primary: Color(0xFFEDEDEE), // Your primary color
//     onPrimary: Colors.white, // Color used on top of primary
//     secondary: Color(0xFF607D8B), // Your secondary color
//     onSecondary: Colors.white, // Color used on top of secondary
//     error: Colors.red,
//     onError: Colors.white,
//     surface: Colors.white,
//     onSurface: Colors.black,
//   ),
//   textTheme: const TextTheme(
//     headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
//     headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//     headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//     titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//     titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//     bodyLarge: TextStyle(fontSize: 18),
//     bodyMedium: TextStyle(fontSize: 16),
//     bodySmall: TextStyle(fontSize: 14, color: Colors.grey),
//     labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//     labelSmall: TextStyle(fontSize: 12, color: Colors.grey),
//   ),
//   // elevatedButtonTheme: ElevatedButtonThemeData(
//   //   style: ElevatedButton.styleFrom(
//   //     //backgroundColor: Colors.indigo,
//   //     padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//   //   ),
//   // ),
// );
