// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_additional_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentAdditionalData _$AppointmentAdditionalDataFromJson(
  Map<String, dynamic> json,
) => AppointmentAdditionalData(
  isClientsChildIncluded: json['isClientsChildIncluded'] as bool?,
  isEmployeeAvailabilityIncluded:
      json['isEmployeeAvailabilityIncluded'] as bool?,
  isAttendanceStatusIncluded: json['isAttendanceStatusIncluded'] as bool?,
);

Map<String, dynamic> _$AppointmentAdditionalDataToJson(
  AppointmentAdditionalData instance,
) => <String, dynamic>{
  'isClientsChildIncluded': instance.isClientsChildIncluded,
  'isEmployeeAvailabilityIncluded': instance.isEmployeeAvailabilityIncluded,
  'isAttendanceStatusIncluded': instance.isAttendanceStatusIncluded,
};
