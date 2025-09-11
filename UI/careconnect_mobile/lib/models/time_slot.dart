import 'package:careconnect_mobile/models/requests/employee_availability_insert_request.dart';
import 'package:careconnect_mobile/providers/utils.dart';
import 'package:flutter/material.dart';

import 'responses/service.dart';

class TimeSlot {
  String day;
  TimeOfDay start;
  TimeOfDay end;
  Service? service;
  // List<String> services;

  TimeSlot({
    required this.day,
    required this.start,
    required this.end,
    this.service,
    //this.services = const [],
  });

  TimeSlot copyWith({
    String? day,
    TimeOfDay? start,
    TimeOfDay? end,
    Service? service,
    //List<String>? services,
  }) {
    return TimeSlot(
      day: day ?? this.day,
      start: start ?? this.start,
      end: end ?? this.end,
      service: service ?? this.service,
      // services: services ?? List.from(this.services),
    );
  }

  EmployeeAvailabilityInsertRequest toInsert(int id) {
    // final startParts = start.split(':');
    // final endParts = end.split(':');

    return EmployeeAvailabilityInsertRequest(
      employeeId: id,
      dayOfWeek: day,
      startTime: formatTimeOfDay(start),
      endTime: formatTimeOfDay(start),
      serviceId: service?.serviceId,
    );
  }

  // Convert to JSON for backend
  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'startTime':
          '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}',
      'endTime':
          '${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}',
      'service': service,
      // 'services': services,
    };
  }
}
