// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qualification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Qualification _$QualificationFromJson(Map<String, dynamic> json) =>
    Qualification(
      name: json['name'] as String,
      instituteName: json['instituteName'] as String,
      procurementYear: DateTime.parse(json['procurementYear'] as String),
      modifiedDate: DateTime.parse(json['modifiedDate'] as String),
    );

Map<String, dynamic> _$QualificationToJson(Qualification instance) =>
    <String, dynamic>{
      'name': instance.name,
      'instituteName': instance.instituteName,
      'procurementYear': instance.procurementYear.toIso8601String(),
      'modifiedDate': instance.modifiedDate.toIso8601String(),
    };
