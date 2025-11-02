// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Participant _$ParticipantFromJson(Map<String, dynamic> json) => Participant(
  participantId: (json['participantId'] as num).toInt(),
  registrationDate: DateTime.parse(json['registrationDate'] as String),
  modifiedDate: DateTime.parse(json['modifiedDate'] as String),
  attendanceStatus: json['attendanceStatus'] == null
      ? null
      : AttendanceStatus.fromJson(
          json['attendanceStatus'] as Map<String, dynamic>,
        ),
  attendanceStatusId: (json['attendanceStatusId'] as num).toInt(),
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
      'participantId': instance.participantId,
      'registrationDate': instance.registrationDate.toIso8601String(),
      'modifiedDate': instance.modifiedDate.toIso8601String(),
      'attendanceStatusId': instance.attendanceStatusId,
      'attendanceStatus': instance.attendanceStatus,
      'user': instance.user,
      'workshop': instance.workshop,
      'child': instance.child,
    };
