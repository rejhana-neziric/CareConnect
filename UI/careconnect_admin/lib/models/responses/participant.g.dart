// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Participant _$ParticipantFromJson(Map<String, dynamic> json) => Participant(
  registrationDate: DateTime.parse(json['registrationDate'] as String),
  modifiedDate: DateTime.parse(json['modifiedDate'] as String),
  attendanceStatus: AttendanceStatus.fromJson(
    json['attendanceStatus'] as Map<String, dynamic>,
  ),
  user: json['user'] == null
      ? null
      : User.fromJson(json['user'] as Map<String, dynamic>),
  workshop: json['workshop'] == null
      ? null
      : Workshop.fromJson(json['workshop'] as Map<String, dynamic>),
  child: json['child'] == null
      ? null
      : Child.fromJson(json['child'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ParticipantToJson(Participant instance) =>
    <String, dynamic>{
      'registrationDate': instance.registrationDate.toIso8601String(),
      'modifiedDate': instance.modifiedDate.toIso8601String(),
      'attendanceStatus': instance.attendanceStatus,
      'user': instance.user,
      'workshop': instance.workshop,
      'child': instance.child,
    };
