import 'package:flutter/material.dart';

// const Color primaryMain = Color(0xFFEDEDEE); // #ededee
// const Color primaryLight = Color(0xFFE8E3EC); // #e8e3ec
// const Color primaryDark = Color(0xFFD9BCD6); // #d9bcd6

// const Color secondaryColor = Color(0xFF9B6F89); // #9b6f89
// const Color accentColor = Color(0xFFA1608C);   // #a1608c

class AppColors {
  static const Color lightGray = Color(0xFFEDEDEE); // Very light gray
  static const Color softLavender = Color(0xFFE8E3EC); // Soft lavender
  static const Color dustyRose = Color(0xFFD9BCD6); // Dusty rose
  static const Color mauveGray = Color(0xFF9B6F89); // Mauve gray
  static const Color deepMauve = Color(0xFFA1608C); // Deep mauve

  // Additional colors for completeness
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color error = Color(0xFFB00020);
}

class AppTheme {
  static ColorScheme get lightColorScheme => ColorScheme.light(
    // Primary colors
    primary: AppColors.deepMauve,
    onPrimary: AppColors.white,
    primaryContainer: AppColors.dustyRose,
    onPrimaryContainer: AppColors.black,

    // Secondary colors
    secondary: AppColors.mauveGray,
    onSecondary: AppColors.white,
    secondaryContainer: AppColors.softLavender,
    onSecondaryContainer: AppColors.black,

    // Surface colors
    surface: AppColors.white,
    onSurface: AppColors.black,
    surfaceVariant: AppColors.lightGray,
    onSurfaceVariant: AppColors.black,

    // Background
    background: AppColors.lightGray,
    onBackground: AppColors.black,

    // Error
    error: AppColors.error,
    onError: AppColors.white,

    // Outline
    outline: AppColors.mauveGray,
  );

  static ColorScheme get darkColorScheme => ColorScheme.dark(
    primary: AppColors.dustyRose,
    onPrimary: AppColors.black,
    primaryContainer: AppColors.deepMauve,
    onPrimaryContainer: AppColors.white,

    secondary: AppColors.softLavender,
    onSecondary: AppColors.black,
    secondaryContainer: AppColors.mauveGray,
    onSecondaryContainer: AppColors.white,

    surface: AppColors.black,
    onSurface: AppColors.lightGray,
    surfaceVariant: AppColors.mauveGray,
    onSurfaceVariant: AppColors.lightGray,

    background: AppColors.black,
    onBackground: AppColors.lightGray,

    error: AppColors.error,
    onError: AppColors.white,

    outline: AppColors.dustyRose,
  );

  // 3. Create ThemeData
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,

    // AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.deepMauve,
      foregroundColor: AppColors.white,
      elevation: 2,
      titleTextStyle: TextStyle(
        color: AppColors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.deepMauve,
        foregroundColor: AppColors.white,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.deepMauve),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      color: AppColors.white,
      shadowColor: AppColors.mauveGray.withOpacity(0.3),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    /*
    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      //fillColor: AppColors.softLavender,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.mauveGray),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.deepMauve, width: 2),
      ),
      labelStyle: TextStyle(color: AppColors.mauveGray),
    ),*/
    dataTableTheme: DataTableThemeData(
      headingRowColor: MaterialStateProperty.all(AppColors.mauveGray),
      headingTextStyle: TextStyle(
        color: AppColors.white,
        fontWeight: FontWeight.w900,
        fontSize: 14,
      ),
      dataRowColor: MaterialStateProperty.all(AppColors.white),
      dataTextStyle: TextStyle(color: AppColors.black, fontSize: 13),
      dividerThickness: 0.2,
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.deepMauve,
      foregroundColor: AppColors.white,
    ),

    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.softLavender,
      labelStyle: TextStyle(color: AppColors.black),
      selectedColor: AppColors.dustyRose,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.black,
      foregroundColor: AppColors.lightGray,
      elevation: 2,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.dustyRose,
        foregroundColor: AppColors.black,
      ),
    ),

    cardTheme: CardThemeData(
      color: AppColors.mauveGray,
      shadowColor: AppColors.black.withOpacity(0.5),
      elevation: 4,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.mauveGray,
      labelStyle: TextStyle(color: AppColors.lightGray),
    ),
  );
}
