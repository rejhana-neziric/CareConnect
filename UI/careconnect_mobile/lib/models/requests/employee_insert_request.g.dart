// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_insert_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeInsertRequest _$EmployeeInsertRequestFromJson(
  Map<String, dynamic> json,
) => EmployeeInsertRequest(
  hireDate: DateTime.parse(json['hireDate'] as String),
  jobTitle: json['jobTitle'] as String,
  user: UserInsertRequest.fromJson(json['user'] as Map<String, dynamic>),
  qualification: json['qualification'] == null
      ? null
      : QualificationInsertRequest.fromJson(
          json['qualification'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$EmployeeInsertRequestToJson(
  EmployeeInsertRequest instance,
) => <String, dynamic>{
  'hireDate': instance.hireDate.toIso8601String(),
  'jobTitle': instance.jobTitle,
  'user': instance.user,
  'qualification': instance.qualification,
};
