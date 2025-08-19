import 'package:flutter/material.dart';

Widget buildSectionTitle(String title, ColorScheme colorScheme) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12.0, top: 8),
    child: Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: colorScheme.primary,
      ),
    ),
  );
}
