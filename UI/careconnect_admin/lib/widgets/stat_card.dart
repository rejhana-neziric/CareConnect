import 'package:careconnect_admin/theme/app_colors.dart';
import 'package:flutter/material.dart';

Widget statCard(String label, dynamic value, IconData icon, Color iconColor) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 1.5,
    color: AppColors.white,
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 400),
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
