// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceType _$ServiceTypeFromJson(Map<String, dynamic> json) => ServiceType(
  serviceTypeId: (json['serviceTypeId'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String?,
  numberOfServices: (json['numberOfServices'] as num?)?.toInt(),
);

Map<String, dynamic> _$ServiceTypeToJson(ServiceType instance) =>
    <String, dynamic>{
      'serviceTypeId': instance.serviceTypeId,
      'name': instance.name,
      'description': instance.description,
      'numberOfServices': instance.numberOfServices,
    };
