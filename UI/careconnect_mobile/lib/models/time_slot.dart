import 'package:careconnect_mobile/models/responses/employee_availability.dart';
import 'package:flutter/material.dart';

class TimeSlot {
  final TimeOfDay time;
  final bool isAvailable;
  final String displayTime;
  final EmployeeAvailability availability;

  TimeSlot({
    required this.time,
    required this.isAvailable,
    required this.displayTime,
    required this.availability,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimeSlot &&
        other.time == time &&
        other.displayTime == displayTime;
  }

  @override
  int get hashCode => time.hashCode ^ displayTime.hashCode;
}
