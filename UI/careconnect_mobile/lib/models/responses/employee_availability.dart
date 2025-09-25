import 'package:careconnect_mobile/models/responses/employee.dart';

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
  final bool isBooked;
  final Service? service;
  final Employee employee;

  EmployeeAvailability({
    required this.employeeAvailabilityId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.isBooked,
    required this.modifiedDate,
    required this.employee,
    this.service,
  });

  factory EmployeeAvailability.fromJson(Map<String, dynamic> json) =>
      _$EmployeeAvailabilityFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeAvailabilityToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EmployeeAvailability &&
        other.dayOfWeek == dayOfWeek &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.service?.serviceId == service?.serviceId;
  }

  @override
  int get hashCode {
    return dayOfWeek.hashCode ^
        startTime.hashCode ^
        endTime.hashCode ^
        service!.serviceId.hashCode;
  }
}
