import 'package:careconnect_admin/models/responses/attendance_status.dart';

import 'package:careconnect_admin/models/responses/employee_availability.dart';

import 'package:json_annotation/json_annotation.dart';

part 'appointment.g.dart';

@JsonSerializable(explicitToJson: true)
class Appointment {
  final int appointmentId;
  final String appointmentType;
  final DateTime date;
  final String? description;
  final String? note;
  final DateTime modifiedDate;
  final AttendanceStatus? attendanceStatus;
  final EmployeeAvailability? employeeAvailability;

  Appointment({
    required this.appointmentId,
    required this.appointmentType,
    required this.date,
    this.description,
    this.note,
    required this.modifiedDate,
    this.attendanceStatus,
    this.employeeAvailability,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) =>
      _$AppointmentFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentToJson(this);
}
