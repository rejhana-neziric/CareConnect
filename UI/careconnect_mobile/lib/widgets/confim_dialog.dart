import 'package:flutter/material.dart';

class CustomConfirmDialog extends StatelessWidget {
  final IconData icon;
  final Color iconBackgroundColor;
  final String title;
  final String content;
  final String confirmText;
  final String? cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const CustomConfirmDialog({
    super.key,
    required this.icon,
    this.iconBackgroundColor = Colors.red,
    required this.title,
    required this.content,
    this.confirmText = 'Continue',
    this.cancelText,
    required this.onConfirm,
    this.onCancel,
  });

  static Future<bool> show(
    BuildContext context, {
    required IconData icon,
    Color iconBackgroundColor = Colors.red,
    required String title,
    required String content,
    String confirmText = 'Continue',
    String? cancelText,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomConfirmDialog(
          icon: icon,
          iconBackgroundColor: iconBackgroundColor,
          title: title,
          content: content,
          confirmText: confirmText,
          cancelText: cancelText,
          onConfirm: () => Navigator.of(context).pop(true),
          onCancel: cancelText != null
              ? () => Navigator.of(context).pop(false)
              : null,
        );
      },
    ).then((value) => value ?? false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            CircleAvatar(
              radius: 30,
              backgroundColor: iconBackgroundColor.withOpacity(0.15),
              child: Icon(icon, color: iconBackgroundColor, size: 30),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: iconBackgroundColor,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 8),

            // Content
            Text(
              content,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),

            // Buttons
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: iconBackgroundColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: onConfirm,
                    child: Text(
                      confirmText,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                if (cancelText != null && onCancel != null) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colorScheme.onSurface,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: onCancel,
                      child: Text(
                        cancelText!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
