import 'service.dart';
import 'employee.dart';

import 'package:json_annotation/json_annotation.dart';

part 'employee_availability.g.dart';

@JsonSerializable(explicitToJson: true)
class EmployeeAvailability {
  final String dayOfWeek;
  final DateTime startTime;
  final DateTime endTime;
  final bool isAvailable;
  final String? reasonOfUnavailability;
  final DateTime modifiedDate;
  final Employee employee;
  final Service? service;

  EmployeeAvailability({
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
    this.reasonOfUnavailability,
    required this.modifiedDate,
    required this.employee,
    this.service,
  });

  factory EmployeeAvailability.fromJson(Map<String, dynamic> json) =>
      _$EmployeeAvailabilityFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeAvailabilityToJson(this);
}
