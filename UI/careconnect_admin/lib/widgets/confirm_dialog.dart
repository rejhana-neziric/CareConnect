import 'package:careconnect_admin/theme/theme_notifier.dart';
import 'package:careconnect_admin/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomConfirmDialog extends StatelessWidget {
  final IconData icon;
  final Color iconBackgroundColor;
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const CustomConfirmDialog({
    Key? key,
    required this.icon,
    this.iconBackgroundColor = Colors.redAccent,
    required this.title,
    required this.content,
    this.confirmText = 'Continue',
    this.cancelText = 'Cancel',
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  static Future<bool> show(
    BuildContext context, {
    required IconData icon,
    Color iconBackgroundColor = Colors.redAccent,
    required String title,
    required String content,
    String confirmText = 'Continue',
    String cancelText = 'Cancel',
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
          onCancel: () => Navigator.of(context).pop(false),
        );
      },
    ).then((value) => value ?? false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: SizedBox(
        width: 600,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon circle
              Container(
                decoration: BoxDecoration(
                  color: iconBackgroundColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(12),
                child: Icon(icon, color: iconBackgroundColor, size: 32),
              ),
              const SizedBox(width: 16),
              // Text and buttons column
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: iconBackgroundColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      content,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        PrimaryButton(
                          onPressed: onConfirm,
                          label: confirmText,
                          backgroundColor: iconBackgroundColor,
                          textColor: Colors.white,
                        ),
                        const SizedBox(width: 12),
                        PrimaryButton(
                          onPressed: onCancel,
                          label: cancelText,
                          backgroundColor: Colors.white,
                          textColor: iconBackgroundColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
