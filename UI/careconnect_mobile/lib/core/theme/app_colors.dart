import 'package:flutter/material.dart';

class AppColors {
  // Primary palette
  static const Color lightGray = Color(0xFFEDEDEE); // Very light gray
  static const Color softLavender = Color(0xFFE8E3EC); // Soft lavender
  static const Color dustyRose = Color(0xFFD9BCD6); // Dusty rose
  static const Color mauveGray = Color(0xFF9B6F89); // Mauve gray
  static const Color deepMauve = Color(0xFFA1608C); // Deep mauve

  // Basic colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color error = Colors.redAccent;
  static const Color darkGray = Color(0xFF2F3432);

  // Dark theme surfaces
  static const Color darkBackground = Color(0xFF1E1E1E);
  static const Color surfaceDark = Color(0xFF2C2C2C);

  // Accent colors (darkened variants for dark theme)
  static const Color accentSoftLavender = Color(0xFF5E5171);
  static const Color accentDustyRose = Color(0xFF8B6279);
  static const Color accentMauveGray = Color(0xFF6D4B5C);
  static const Color accentDeepMauve = Color(0xFF7C3F6B);

  // Text colors
  static const Color textPrimaryLight = Color(
    0xFF2F3432,
  ); // Dark text for light theme
  static const Color textSecondaryLight = Color(0xFF6D5E70);
  static const Color textPrimaryDark = Color(
    0xFFEDEDEE,
  ); // Light text for dark theme
  static const Color textSecondaryDark = Color(0xFFB0A6B8);
}

class AppSurfaces {
  // --------------------------
  // Light theme surfaces
  // --------------------------
  static const Color lightSurfaceContainerLowest =
      AppColors.white; // default background
  static const Color lightSurfaceContainerLow =
      AppColors.lightGray; // slightly elevated
  static const Color lightSurfaceContainer =
      AppColors.softLavender; // default card/panel
  static const Color lightSurfaceContainerHigh =
      AppColors.dustyRose; // higher elevation (hover/overlay)
  static const Color lightSurfaceContainerHighest =
      AppColors.deepMauve; // topmost elevation/modal

  // --------------------------
  // Dark theme surfaces
  // --------------------------
  static const Color darkSurfaceContainerLowest =
      AppColors.darkBackground; // default background
  static const Color darkSurfaceContainerLow =
      AppColors.surfaceDark; // slightly elevated
  static const Color darkSurfaceContainer =
      AppColors.mauveGray; // default card/panel
  static const Color darkSurfaceContainerHigh =
      AppColors.accentDustyRose; // higher elevation (hover/overlay)
  static const Color darkSurfaceContainerHighest =
      AppColors.accentDeepMauve; // topmost elevation/modal
}

class AppTheme {
  // Light Theme ColorScheme
  static ColorScheme get lightColorScheme => ColorScheme.light(
    primary: AppColors.deepMauve,
    onPrimary: AppColors.white,
    primaryContainer: AppColors.dustyRose,
    onPrimaryContainer: AppColors.black,
    // secondary: AppColors.mauveGray,
    secondary: AppColors.dustyRose,
    onSecondary: AppColors.white,
    secondaryContainer: AppColors.softLavender,
    onSecondaryContainer: AppColors.black,
    surface: AppSurfaces.lightSurfaceContainer,
    onSurface: AppColors.textPrimaryLight,
    surfaceContainerLowest: AppSurfaces.lightSurfaceContainerLowest,
    surfaceContainerLow: AppSurfaces.lightSurfaceContainerLow,
    surfaceContainer: AppSurfaces.lightSurfaceContainer,
    surfaceContainerHigh: AppSurfaces.lightSurfaceContainerHigh,
    surfaceContainerHighest: AppSurfaces.lightSurfaceContainerHighest,
    error: AppColors.error,
    onError: AppColors.white,
    outline: AppColors.mauveGray,
  );

  // Dark Theme ColorScheme
  static ColorScheme get darkColorScheme => ColorScheme.dark(
    primary: AppColors.accentDeepMauve,
    onPrimary: AppColors.black,
    primaryContainer: AppColors.deepMauve,
    onPrimaryContainer: AppColors.white,
    // secondary: AppColors.softLavender,
    secondary: AppColors.dustyRose,
    onSecondary: AppColors.black,
    secondaryContainer: AppColors.mauveGray,
    onSecondaryContainer: AppColors.white,
    surface: AppSurfaces
        .darkSurfaceContainerLowest, //AppSurfaces.darkSurfaceContainer,
    onSurface: AppColors.textPrimaryDark,
    surfaceContainerLowest: AppSurfaces.darkSurfaceContainerLowest,
    surfaceContainerLow: AppSurfaces.darkSurfaceContainerLow,
    surfaceContainer: AppSurfaces.darkSurfaceContainer,
    surfaceContainerHigh: AppSurfaces.darkSurfaceContainerHigh,
    surfaceContainerHighest: AppSurfaces.darkSurfaceContainerHighest,
    error: AppColors.error,
    onError: AppColors.white,
    outline: AppColors.dustyRose,
  );

  // Light ThemeData
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
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
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.deepMauve,
        foregroundColor: AppColors.white,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.deepMauve),
    ),
    cardTheme: CardThemeData(
      color: AppColors.white,
      shadowColor: AppColors.mauveGray.withValues(alpha: 0.3),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    dataTableTheme: DataTableThemeData(
      headingRowColor: MaterialStateProperty.all(AppColors.mauveGray),
      headingTextStyle: TextStyle(
        color: AppColors.white,
        fontWeight: FontWeight.w900,
        fontSize: 14,
        inherit: false,
      ),
      dataRowColor: MaterialStateProperty.all(AppColors.white),
      dataTextStyle: TextStyle(
        color: AppColors.textPrimaryLight,
        fontSize: 13,
        inherit: false,
      ),
      dividerThickness: 0.2,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.deepMauve,
      foregroundColor: AppColors.white,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.softLavender,
      labelStyle: TextStyle(color: AppColors.textPrimaryLight),
      selectedColor: AppColors.dustyRose,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.white, // your custom color
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: AppSurfaces.lightSurfaceContainerLowest,
    ),
  );

  // Dark ThemeData
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.black,
      foregroundColor: AppColors.textPrimaryDark,
      elevation: 2,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.dustyRose,
        foregroundColor: AppColors.black,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.deepMauve),
    ),
    cardTheme: CardThemeData(
      color: AppSurfaces.darkSurfaceContainerLowest,
      shadowColor: AppColors.black.withValues(alpha: 0.5),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceDark,
      labelStyle: TextStyle(color: AppColors.textSecondaryDark),
    ),
    dataTableTheme: DataTableThemeData(
      headingRowColor: MaterialStateProperty.all(AppColors.accentMauveGray),
      headingTextStyle: TextStyle(
        color: AppColors.white,
        fontWeight: FontWeight.w900,
        fontSize: 14,
        inherit: false,
      ),
      dataRowColor: MaterialStateProperty.all(AppColors.darkBackground),
      dataTextStyle: TextStyle(
        color: AppColors.textPrimaryDark,
        fontSize: 13,
        inherit: false,
      ),
      dividerThickness: 0.2,
    ),

    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.darkGray,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    datePickerTheme: DatePickerThemeData(
      backgroundColor: AppSurfaces.darkSurfaceContainerLowest,
    ),
  );
}
