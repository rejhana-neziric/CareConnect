// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qualification_insert_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QualificationInsertRequest _$QualificationInsertRequestFromJson(
  Map<String, dynamic> json,
) => QualificationInsertRequest(
  name: json['name'] as String,
  instituteName: json['instituteName'] as String,
  procurementYear: DateTime.parse(json['procurementYear'] as String),
);

Map<String, dynamic> _$QualificationInsertRequestToJson(
  QualificationInsertRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'instituteName': instance.instituteName,
  'procurementYear': instance.procurementYear.toIso8601String(),
};
