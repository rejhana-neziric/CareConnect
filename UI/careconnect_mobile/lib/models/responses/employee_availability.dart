import 'package:careconnect_mobile/models/responses/employee.dart';
import 'package:careconnect_mobile/models/time_slot.dart';
import 'package:flutter/material.dart';

import 'service.dart';

import 'package:json_annotation/json_annotation.dart';

part 'employee_availability.g.dart';

@JsonSerializable(explicitToJson: true)
class EmployeeAvailability {
  final int employeeAvailabilityId;
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final DateTime modifiedDate;
  final Service? service;
  final Employee employee;

  EmployeeAvailability({
    required this.employeeAvailabilityId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.modifiedDate,
    required this.employee,
    this.service,
  });

  factory EmployeeAvailability.fromJson(Map<String, dynamic> json) =>
      _$EmployeeAvailabilityFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeAvailabilityToJson(this);

  TimeSlot toTimeSlot() {
    final startParts = startTime.split(':');
    final endParts = endTime.split(':');

    return TimeSlot(
      day: dayOfWeek,
      start: TimeOfDay(
        hour: int.parse(startParts[0]),
        minute: int.parse(startParts[1]),
      ),
      end: TimeOfDay(
        hour: int.parse(endParts[0]),
        minute: int.parse(endParts[1]),
      ),
      service: service,
    );
  }

  // factory EmployeeAvailability.fromTimeSlot(
  //   TimeSlot timeSlot,
  //   int employeeId,
  // ) {
  //   return EmployeeAvailability(
  //     employeeAvailabilityId: ,
  //     employeeId: employeeId,
  //     dayOfWeek: timeSlot.day,
  //     startTime:
  //         '${timeSlot.start.hour.toString().padLeft(2, '0')}:${timeSlot.start.minute.toString().padLeft(2, '0')}',
  //     endTime:
  //         '${timeSlot.end.hour.toString().padLeft(2, '0')}:${timeSlot.end.minute.toString().padLeft(2, '0')}',
  //     serviceId: timeSlot.service?.serviceId,
  //   );
  // }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EmployeeAvailability &&
        other.dayOfWeek == dayOfWeek &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.service?.serviceId == service?.serviceId;
  }

  //fix
  @override
  int get hashCode {
    return dayOfWeek.hashCode ^
        startTime.hashCode ^
        endTime.hashCode ^
        service!.serviceId.hashCode;
  }
}
