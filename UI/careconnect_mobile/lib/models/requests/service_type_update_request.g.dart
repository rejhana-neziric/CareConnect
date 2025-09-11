// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_type_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceTypeUpdateRequest _$ServiceTypeUpdateRequestFromJson(
  Map<String, dynamic> json,
) => ServiceTypeUpdateRequest(
  name: json['name'] as String?,
  description: json['description'] as String?,
);

Map<String, dynamic> _$ServiceTypeUpdateRequestToJson(
  ServiceTypeUpdateRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
};
