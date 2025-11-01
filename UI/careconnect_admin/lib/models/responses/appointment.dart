import 'package:careconnect_admin/models/responses/attendance_status.dart';
import 'package:careconnect_admin/models/responses/clients_child.dart';

import 'package:careconnect_admin/models/responses/employee_availability.dart';

import 'package:json_annotation/json_annotation.dart';

part 'appointment.g.dart';

@JsonSerializable(explicitToJson: true)
class Appointment {
  final int appointmentId;
  final int employeeAvailabilityId;
  final String appointmentType;
  final int attendanceStatusId;
  final DateTime date;
  final String? description;
  final String? note;
  String? stateMachine;
  final bool paid;
  final DateTime modifiedDate;
  final AttendanceStatus? attendanceStatus;
  final EmployeeAvailability? employeeAvailability;
  final int clientId;
  final int childId;
  final ClientsChild clientsChild;

  Appointment({
    required this.appointmentId,
    required this.employeeAvailabilityId,
    required this.appointmentType,
    required this.attendanceStatusId,
    required this.date,
    this.description,
    this.note,
    this.stateMachine,
    required this.paid,
    required this.modifiedDate,
    this.attendanceStatus,
    this.employeeAvailability,
    required this.clientId,
    required this.childId,
    required this.clientsChild,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) =>
      _$AppointmentFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentToJson(this);
}
