import 'dart:convert';

import 'package:careconnect_mobile/widgets/filter/filter.dart';
import 'package:careconnect_mobile/widgets/filter/filter_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (context, scrollController) => FilterWidget(
        config: config,
        onApply: onApply,
        onClearAll: onClearAll,
      ),
    ),
  );
}
