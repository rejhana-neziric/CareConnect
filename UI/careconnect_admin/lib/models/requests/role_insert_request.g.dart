// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_insert_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoleInsertRequest _$RoleInsertRequestFromJson(Map<String, dynamic> json) =>
    RoleInsertRequest(
      name: json['name'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$RoleInsertRequestToJson(RoleInsertRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
    };
