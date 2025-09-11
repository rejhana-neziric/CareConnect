// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_type_insert_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceTypeInsertRequest _$ServiceTypeInsertRequestFromJson(
  Map<String, dynamic> json,
) => ServiceTypeInsertRequest(
  name: json['name'] as String,
  description: json['description'] as String?,
);

Map<String, dynamic> _$ServiceTypeInsertRequestToJson(
  ServiceTypeInsertRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
};
