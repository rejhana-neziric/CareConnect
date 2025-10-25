import 'package:careconnect_admin/widgets/shimmer_widget.dart';
import 'package:flutter/material.dart';

Widget shimmerStatCard(BuildContext context, {double width = 400}) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 1.5,
    color: colorScheme.surfaceContainerLowest,
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: width),
      child: ShimmerWidget(width: width, height: 100),
    ),
  );
}
