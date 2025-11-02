import 'dart:convert';

import 'package:careconnect_mobile/widgets/filter/filter.dart';
import 'package:careconnect_mobile/widgets/filter/filter_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatNumber(dynamic) {
  var f = NumberFormat('###,00');

  if (dynamic == null) {
    return "";
  }

  return f.format(dynamic);
}

Image imageFromString(String input) {
  return Image.memory(base64Decode(input));
}

String formatTimeOfDay(TimeOfDay tod) {
  final hour = tod.hour.toString().padLeft(2, '0');
  final minute = tod.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

void showGenericFilter({
  required BuildContext context,
  required FilterConfig config,
  required Function(Map<String, List<String>>) onApply,
  VoidCallback? onClearAll,
  required Map<String, List<String>> initialFilters,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (context, scrollController) => FilterWidget(
        config: config,
        initialFilters: initialFilters,
        onApply: onApply,
        onClearAll: onClearAll,
      ),
    ),
  );
}
