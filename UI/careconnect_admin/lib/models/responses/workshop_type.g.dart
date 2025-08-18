// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workshop_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkshopType _$WorkshopTypeFromJson(Map<String, dynamic> json) => WorkshopType(
  workshopTypeId: (json['workshopTypeId'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String?,
  modifiedDate: DateTime.parse(json['modifiedDate'] as String),
);

Map<String, dynamic> _$WorkshopTypeToJson(WorkshopType instance) =>
    <String, dynamic>{
      'workshopTypeId': instance.workshopTypeId,
      'name': instance.name,
      'description': instance.description,
      'modifiedDate': instance.modifiedDate.toIso8601String(),
    };
