import 'package:careconnect_admin/models/requests/employee_availability_insert_request.dart';
import 'package:careconnect_admin/providers/utils.dart';
import 'package:flutter/material.dart';

import 'responses/service.dart';

class TimeSlot {
  String day;
  TimeOfDay start;
  TimeOfDay end;
  Service? service;

  TimeSlot({
    required this.day,
    required this.start,
    required this.end,
    this.service,
  });

  TimeSlot copyWith({
    String? day,
    TimeOfDay? start,
    TimeOfDay? end,
    Service? service,
  }) {
    return TimeSlot(
      day: day ?? this.day,
      start: start ?? this.start,
      end: end ?? this.end,
      service: service ?? this.service,
    );
  }

  EmployeeAvailabilityInsertRequest toInsert(int id) {
    return EmployeeAvailabilityInsertRequest(
      employeeId: id,
      dayOfWeek: day,
      startTime: formatTimeOfDay(start),
      endTime: formatTimeOfDay(start),
      serviceId: service?.serviceId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'startTime':
          '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}',
      'endTime':
          '${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}',
      'service': service,
    };
  }
}
