// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Employee _$EmployeeFromJson(Map<String, dynamic> json) => Employee(
  hireDate: DateTime.parse(json['hireDate'] as String),
  endDate: json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String),
  jobTitle: json['jobTitle'] as String,
  modifiedDate: DateTime.parse(json['modifiedDate'] as String),
  user: User.fromJson(json['user'] as Map<String, dynamic>),
  qualification: json['qualification'] == null
      ? null
      : Qualification.fromJson(json['qualification'] as Map<String, dynamic>),
);

Map<String, dynamic> _$EmployeeToJson(Employee instance) => <String, dynamic>{
  'hireDate': instance.hireDate.toIso8601String(),
  'endDate': instance.endDate?.toIso8601String(),
  'jobTitle': instance.jobTitle,
  'modifiedDate': instance.modifiedDate.toIso8601String(),
  'user': instance.user.toJson(),
  'qualification': instance.qualification?.toJson(),
};
