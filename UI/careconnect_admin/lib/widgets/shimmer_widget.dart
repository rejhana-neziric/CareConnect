import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final num width;
  final num height;

  const ShimmerWidget({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: width.toDouble(),
      height: height.toDouble(),
      child: Shimmer.fromColors(
        baseColor: theme.colorScheme.surfaceContainerLowest.withAlpha(
          (0.9 * 255).toInt(),
        ),
        highlightColor: theme.colorScheme.secondary.withAlpha(
          (0.9 * 255).toInt(),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: theme.colorScheme.surfaceContainerLowest,
          ),
        ),
      ),
    );
  }
}
