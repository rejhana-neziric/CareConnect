import 'package:flutter/material.dart';

Widget statCard(
  BuildContext context,
  String label,
  dynamic value,
  IconData icon,
  Color iconColor, {
  double width = 400,
}) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 1.5,
    color: colorScheme.surfaceContainerLowest,
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: width),
      child: Container(
        height: 100,
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withAlpha((0.1 * 255).toInt()),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 25),
            ),
            SizedBox(width: 16),
            // Text info
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$value',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
