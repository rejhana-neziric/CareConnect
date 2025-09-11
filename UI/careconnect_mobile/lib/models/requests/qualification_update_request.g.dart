// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qualification_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QualificationUpdateRequest _$QualificationUpdateRequestFromJson(
  Map<String, dynamic> json,
) => QualificationUpdateRequest(
  name: json['name'] as String?,
  instituteName: json['instituteName'] as String?,
  procurementYear: json['procurementYear'] == null
      ? null
      : DateTime.parse(json['procurementYear'] as String),
);

Map<String, dynamic> _$QualificationUpdateRequestToJson(
  QualificationUpdateRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'instituteName': instance.instituteName,
  'procurementYear': instance.procurementYear?.toIso8601String(),
};
