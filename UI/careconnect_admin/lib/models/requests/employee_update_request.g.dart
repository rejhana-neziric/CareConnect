// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeUpdateRequest _$EmployeeUpdateRequestFromJson(
  Map<String, dynamic> json,
) => EmployeeUpdateRequest(
  jobTitle: json['jobTitle'] as String?,
  user: json['user'] == null
      ? null
      : UserUpdateRequest.fromJson(json['user'] as Map<String, dynamic>),
  qualification: json['qualification'] == null
      ? null
      : QualificationUpdateRequest.fromJson(
          json['qualification'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$EmployeeUpdateRequestToJson(
  EmployeeUpdateRequest instance,
) => <String, dynamic>{
  'jobTitle': instance.jobTitle,
  'user': instance.user,
  'qualification': instance.qualification,
};
