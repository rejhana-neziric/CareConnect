// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_availability_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeAvailabilityUpdateRequest _$EmployeeAvailabilityUpdateRequestFromJson(
  Map<String, dynamic> json,
) => EmployeeAvailabilityUpdateRequest(
  serviceId: (json['serviceId'] as num?)?.toInt(),
  dayOfWeek: json['dayOfWeek'] as String?,
  startTime: json['startTime'] as String?,
  endTime: json['endTime'] as String?,
);

Map<String, dynamic> _$EmployeeAvailabilityUpdateRequestToJson(
  EmployeeAvailabilityUpdateRequest instance,
) => <String, dynamic>{
  'serviceId': instance.serviceId,
  'dayOfWeek': instance.dayOfWeek,
  'startTime': instance.startTime,
  'endTime': instance.endTime,
};
