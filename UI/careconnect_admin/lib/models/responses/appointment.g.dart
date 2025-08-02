// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Appointment _$AppointmentFromJson(Map<String, dynamic> json) => Appointment(
  appointmentId: (json['appointmentId'] as num).toInt(),
  appointmentType: json['appointmentType'] as String,
  date: DateTime.parse(json['date'] as String),
  description: json['description'] as String?,
  note: json['note'] as String?,
  modifiedDate: DateTime.parse(json['modifiedDate'] as String),
  attendanceStatus: json['attendanceStatus'] == null
      ? null
      : AttendanceStatus.fromJson(
          json['attendanceStatus'] as Map<String, dynamic>,
        ),
  employeeAvailability: json['employeeAvailability'] == null
      ? null
      : EmployeeAvailability.fromJson(
          json['employeeAvailability'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$AppointmentToJson(Appointment instance) =>
    <String, dynamic>{
      'appointmentId': instance.appointmentId,
      'appointmentType': instance.appointmentType,
      'date': instance.date.toIso8601String(),
      'description': instance.description,
      'note': instance.note,
      'modifiedDate': instance.modifiedDate.toIso8601String(),
      'attendanceStatus': instance.attendanceStatus?.toJson(),
      'employeeAvailability': instance.employeeAvailability?.toJson(),
    };
