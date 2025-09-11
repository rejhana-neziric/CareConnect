// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentSearchObject _$AppointmentSearchObjectFromJson(
  Map<String, dynamic> json,
) => AppointmentSearchObject(
  fts: json['fts'] as String?,
  appointmentType: json['appointmentType'] as String?,
  dateGTE: json['dateGTE'] == null
      ? null
      : DateTime.parse(json['dateGTE'] as String),
  dateLTE: json['dateLTE'] == null
      ? null
      : DateTime.parse(json['dateLTE'] as String),
  attendanceStatusName: json['attendanceStatusName'] as String?,
  employeeFirstName: json['employeeFirstName'] as String?,
  employeeLastName: json['employeeLastName'] as String?,
  startTime: json['startTime'] as String?,
  endTime: json['endTime'] as String?,
  status: json['status'] as String?,
  childFirstName: json['childFirstName'] as String?,
  childLastName: json['childLastName'] as String?,
  clientId: (json['clientId'] as num?)?.toInt(),
  clientUsername: json['clientUsername'] as String?,
  serviceTypeId: (json['serviceTypeId'] as num?)?.toInt(),
  serviceNameGTE: json['serviceNameGTE'] as String?,
  additionalData: json['additionalData'] == null
      ? null
      : AppointmentAdditionalData.fromJson(
          json['additionalData'] as Map<String, dynamic>,
        ),
  page: (json['page'] as num?)?.toInt(),
  sortAscending: json['sortAscending'] as bool?,
  includeTotalCount: json['includeTotalCount'] as bool?,
  sortBy: json['sortBy'] as String?,
);

Map<String, dynamic> _$AppointmentSearchObjectToJson(
  AppointmentSearchObject instance,
) => <String, dynamic>{
  'fts': instance.fts,
  'appointmentType': instance.appointmentType,
  'dateGTE': instance.dateGTE?.toIso8601String(),
  'dateLTE': instance.dateLTE?.toIso8601String(),
  'attendanceStatusName': instance.attendanceStatusName,
  'employeeFirstName': instance.employeeFirstName,
  'employeeLastName': instance.employeeLastName,
  'startTime': instance.startTime,
  'endTime': instance.endTime,
  'status': instance.status,
  'childFirstName': instance.childFirstName,
  'childLastName': instance.childLastName,
  'clientId': instance.clientId,
  'clientUsername': instance.clientUsername,
  'serviceTypeId': instance.serviceTypeId,
  'serviceNameGTE': instance.serviceNameGTE,
  'additionalData': instance.additionalData?.toJson(),
  'page': instance.page,
  'sortBy': instance.sortBy,
  'sortAscending': instance.sortAscending,
  'includeTotalCount': instance.includeTotalCount,
};
