// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Child _$ChildFromJson(Map<String, dynamic> json) => Child(
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  birthDate: DateTime.parse(json['birthDate'] as String),
  gender: json['gender'] as String,
);

Map<String, dynamic> _$ChildToJson(Child instance) => <String, dynamic>{
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'birthDate': instance.birthDate.toIso8601String(),
  'gender': instance.gender,
};
