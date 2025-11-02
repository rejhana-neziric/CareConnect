import 'dart:convert';
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
