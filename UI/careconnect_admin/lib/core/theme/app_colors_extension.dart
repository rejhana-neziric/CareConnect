import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color primaryLight;
  final Color primaryDark;
  final Color accent;

  const AppColors({
    required this.primaryLight,
    required this.primaryDark,
    required this.accent,
  });

  @override
  AppColors copyWith({Color? primaryLight, Color? primaryDark, Color? accent}) {
    return AppColors(
      primaryLight: primaryLight ?? this.primaryLight,
      primaryDark: primaryDark ?? this.primaryDark,
      accent: accent ?? this.accent,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
    );
  }
}
