import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;

  const PrimaryButton({
    Key? key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bgColor = backgroundColor ?? colorScheme.primary;
    final fgColor = textColor ?? Colors.white;

    final ButtonStyle style = TextButton.styleFrom(
      backgroundColor: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );

    if (icon != null) {
      return TextButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: fgColor),
        label: Text(
          label,
          style: TextStyle(color: fgColor, fontWeight: FontWeight.w500),
        ),
        style: style,
      );
    } else {
      return TextButton(
        onPressed: onPressed,
        style: style,
        child: Text(
          label,
          style: TextStyle(color: fgColor, fontWeight: FontWeight.w500),
        ),
      );
    }
  }
}
