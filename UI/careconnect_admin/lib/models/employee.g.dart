// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Employee _$EmployeeFromJson(Map<String, dynamic> json) => Employee()
  ..hireDate = json['hireDate'] == null
      ? null
      : DateTime.parse(json['hireDate'] as String)
  ..jobTitle = json['jobTitle'] as String?;

Map<String, dynamic> _$EmployeeToJson(Employee instance) => <String, dynamic>{
  'hireDate': instance.hireDate?.toIso8601String(),
  'jobTitle': instance.jobTitle,
};
