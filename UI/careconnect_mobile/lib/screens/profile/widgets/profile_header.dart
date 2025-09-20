import 'package:careconnect_mobile/models/responses/user.dart';
import 'package:flutter/material.dart';

Widget buildProfileHeader(
  BuildContext context,
  User? user,
  ColorScheme colorScheme, {
  bool backArrow = true,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 40),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [colorScheme.primary, colorScheme.secondary],
      ),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (backArrow)
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        CircleAvatar(
          radius: 58,
          backgroundColor: Colors.white,
          child: Text(
            _getInitials(user),
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _getFullName(user),
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '@${user?.username ?? 'N/A'}',
          style: TextStyle(fontSize: 18, color: Colors.white.withOpacity(0.9)),
        ),
      ],
    ),
  );
}

String _getInitials(User? user) {
  if (user == null) return 'N/A';
  final firstInitial = (user.firstName.isNotEmpty) ? user.firstName[0] : '';
  final lastInitial = (user.lastName.isNotEmpty) ? user.lastName[0] : '';
  return '$firstInitial$lastInitial'.toUpperCase();
}

String _getFullName(User? user) {
  if (user == null) return 'No User Data';
  final firstName = user.firstName;
  final lastName = user.lastName;
  return '$firstName $lastName'.trim().isEmpty
      ? 'No User Data'
      : '$firstName $lastName';
}
