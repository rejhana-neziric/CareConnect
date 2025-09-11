// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeSearchObject _$EmployeeSearchObjectFromJson(
  Map<String, dynamic> json,
) => EmployeeSearchObject(
  fts: json['fts'] as String?,
  firstNameGTE: json['firstNameGTE'] as String?,
  lastNameGTE: json['lastNameGTE'] as String?,
  email: json['email'] as String?,
  jobTitle: json['jobTitle'] as String?,
  hireDateGTE: json['hireDateGTE'] == null
      ? null
      : DateTime.parse(json['hireDateGTE'] as String),
  hireDateLTE: json['hireDateLTE'] == null
      ? null
      : DateTime.parse(json['hireDateLTE'] as String),
  employed: json['employed'] as bool?,
  page: (json['page'] as num?)?.toInt(),
  sortBy: json['sortBy'] as String?,
  sortAscending: json['sortAscending'] as bool?,
  additionalData: json['additionalData'] == null
      ? null
      : EmployeeAdditionalData.fromJson(
          json['additionalData'] as Map<String, dynamic>,
        ),
  includeTotalCount: json['includeTotalCount'] as bool?,
);

Map<String, dynamic> _$EmployeeSearchObjectToJson(
  EmployeeSearchObject instance,
) => <String, dynamic>{
  'fts': instance.fts,
  'firstNameGTE': instance.firstNameGTE,
  'lastNameGTE': instance.lastNameGTE,
  'email': instance.email,
  'jobTitle': instance.jobTitle,
  'hireDateGTE': instance.hireDateGTE?.toIso8601String(),
  'hireDateLTE': instance.hireDateLTE?.toIso8601String(),
  'employed': instance.employed,
  'page': instance.page,
  'sortBy': instance.sortBy,
  'sortAscending': instance.sortAscending,
  'additionalData': instance.additionalData?.toJson(),
  'includeTotalCount': instance.includeTotalCount,
};
