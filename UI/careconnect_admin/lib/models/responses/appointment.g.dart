// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Appointment _$AppointmentFromJson(Map<String, dynamic> json) => Appointment(
  appointmentId: (json['appointmentId'] as num).toInt(),
  employeeAvailabilityId: (json['employeeAvailabilityId'] as num).toInt(),
  appointmentType: json['appointmentType'] as String,
  attendanceStatusId: (json['attendanceStatusId'] as num).toInt(),
  date: DateTime.parse(json['date'] as String),
  description: json['description'] as String?,
  note: json['note'] as String?,
  stateMachine: json['stateMachine'] as String?,
  paid: json['paid'] as bool,
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
  clientId: (json['clientId'] as num).toInt(),
  childId: (json['childId'] as num).toInt(),
  clientsChild: ClientsChild.fromJson(
    json['clientsChild'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$AppointmentToJson(Appointment instance) =>
    <String, dynamic>{
      'appointmentId': instance.appointmentId,
      'employeeAvailabilityId': instance.employeeAvailabilityId,
      'appointmentType': instance.appointmentType,
      'attendanceStatusId': instance.attendanceStatusId,
      'date': instance.date.toIso8601String(),
      'description': instance.description,
      'note': instance.note,
      'stateMachine': instance.stateMachine,
      'paid': instance.paid,
      'modifiedDate': instance.modifiedDate.toIso8601String(),
      'attendanceStatus': instance.attendanceStatus?.toJson(),
      'employeeAvailability': instance.employeeAvailability?.toJson(),
      'clientId': instance.clientId,
      'childId': instance.childId,
      'clientsChild': instance.clientsChild.toJson(),
    };
