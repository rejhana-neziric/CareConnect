import 'package:flutter/material.dart';

enum SnackbarType { success, warning, error, info, custom }

class CustomSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    SnackbarType type = SnackbarType.info,
    Duration duration = const Duration(seconds: 3),
    IconData? icon,
  }) {
    Color bgColor;
    IconData defaultIcon;

    switch (type) {
      case SnackbarType.success:
        bgColor = Colors.green.shade600;
        defaultIcon = Icons.check_circle;
        break;
      case SnackbarType.warning:
        bgColor = Colors.orange.shade600;
        defaultIcon = Icons.warning_amber_rounded;
        break;
      case SnackbarType.error:
        bgColor = Colors.red.shade600;
        defaultIcon = Icons.error;
        break;
      case SnackbarType.info:
        bgColor = Colors.blue.shade600;
        defaultIcon = Icons.info;
        break;
      case SnackbarType.custom:
        bgColor = Colors.grey.shade800;
        defaultIcon = icon ?? Icons.notifications;
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: duration,
        behavior: SnackBarBehavior.floating,
        backgroundColor: bgColor,
        content: Row(
          children: [
            Icon(icon ?? defaultIcon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
    );
  }
}
