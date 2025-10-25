// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';

// Widget shimmerBarChartPlaceholder(BuildContext context) {
//   final theme = Theme.of(context);
//   final colorScheme = theme.colorScheme;

//   return Shimmer.fromColors(
//     baseColor: colorScheme.surfaceContainerLowest.withAlpha(
//       (0.9 * 255).toInt(),
//     ),
//     highlightColor: theme.colorScheme.secondary.withAlpha(
//       (0.9 * 255).toInt(),
//     ), // sh
//     child: Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: theme.colorScheme.surfaceContainerLowest,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             height: 20,
//             width: 120,
//             color: colorScheme.surfaceContainerLowest,
//             margin: const EdgeInsets.only(bottom: 24),
//           ),
//         ],
//       ),
//     ),
//   );
// }
