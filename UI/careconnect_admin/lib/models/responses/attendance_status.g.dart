// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceStatus _$AttendanceStatusFromJson(Map<String, dynamic> json) =>
    AttendanceStatus(
      attendanceStatusId: (json['attendanceStatusId'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$AttendanceStatusToJson(AttendanceStatus instance) =>
    <String, dynamic>{
      'attendanceStatusId': instance.attendanceStatusId,
      'name': instance.name,
    };
