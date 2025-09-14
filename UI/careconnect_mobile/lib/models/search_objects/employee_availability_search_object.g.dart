// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_availability_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeAvailabilitySearchObject _$EmployeeAvailabilitySearchObjectFromJson(
  Map<String, dynamic> json,
) => EmployeeAvailabilitySearchObject(
  fts: json['fts'] as String?,
  dayOfWeek: json['dayOfWeek'] as String?,
  startTime: json['startTime'] as String?,
  endTime: json['endTime'] as String?,
  employeeFirstNameGTE: json['employeeFirstNameGTE'] as String?,
  employeeLastNameGTE: json['employeeLastNameGTE'] as String?,
  serviceNameGTE: json['serviceNameGTE'] as String?,
  employeeId: (json['employeeId'] as num?)?.toInt(),
  serviceId: (json['serviceId'] as num?)?.toInt(),
  page: (json['page'] as num?)?.toInt(),
  sortBy: json['sortBy'] as String?,
  sortAscending: json['sortAscending'] as bool?,
  additionalData: json['additionalData'] == null
      ? null
      : EmployeeAvailabilityAdditionalData.fromJson(
          json['additionalData'] as Map<String, dynamic>,
        ),
  includeTotalCount: json['includeTotalCount'] as bool?,
);

Map<String, dynamic> _$EmployeeAvailabilitySearchObjectToJson(
  EmployeeAvailabilitySearchObject instance,
) => <String, dynamic>{
  'fts': instance.fts,
  'dayOfWeek': instance.dayOfWeek,
  'startTime': instance.startTime,
  'endTime': instance.endTime,
  'employeeFirstNameGTE': instance.employeeFirstNameGTE,
  'employeeLastNameGTE': instance.employeeLastNameGTE,
  'serviceNameGTE': instance.serviceNameGTE,
  'employeeId': instance.employeeId,
  'serviceId': instance.serviceId,
  'page': instance.page,
  'sortBy': instance.sortBy,
  'sortAscending': instance.sortAscending,
  'includeTotalCount': instance.includeTotalCount,
  'additionalData': instance.additionalData?.toJson(),
};
