// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_insert_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChildInsertRequest _$ChildInsertRequestFromJson(Map<String, dynamic> json) =>
    ChildInsertRequest(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      birthDate: DateTime.parse(json['birthDate'] as String),
      gender: json['gender'] as String,
    );

Map<String, dynamic> _$ChildInsertRequestToJson(ChildInsertRequest instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'birthDate': instance.birthDate.toIso8601String(),
      'gender': instance.gender,
    };
