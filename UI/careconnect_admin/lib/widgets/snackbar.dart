import 'package:flutter/material.dart';

enum SnackbarType { success, warning, error, info, custom }

class CustomSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    SnackbarType type = SnackbarType.info,
    String? actionLabel,
    VoidCallback? onAction,
    Color? backgroundColor,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
    double borderRadius = 8.0,
    double elevation = 4.0,
  }) {
    Color bgColor;
    IconData defaultIcon;

    switch (type) {
      case SnackbarType.success:
        bgColor = Colors.green.shade600;
        defaultIcon = Icons.check_circle_outline_outlined;
        break;
      case SnackbarType.warning:
        bgColor = Colors.orange.shade600;
        defaultIcon = Icons.warning_amber_outlined;
        break;
      case SnackbarType.error:
        bgColor = Colors.red.shade600;
        defaultIcon = Icons.error_outline;
        break;
      case SnackbarType.info:
        bgColor = Colors.blue.shade600;
        defaultIcon = Icons.info_outline;
        break;
      case SnackbarType.custom:
        bgColor = backgroundColor ?? Colors.grey.shade800;
        defaultIcon = icon ?? Icons.notifications_none;
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: bgColor,
        elevation: elevation,
        duration: duration,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        content: Row(
          children: [
            Icon(icon ?? defaultIcon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                onPressed: onAction ?? () {},
                textColor: Colors.white,
              )
            : null,
      ),
    );
  }
}
