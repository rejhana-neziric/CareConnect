// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Permission _$PermissionFromJson(Map<String, dynamic> json) => Permission(
  permissionId: (json['permissionId'] as num).toInt(),
  name: json['name'] as String,
  category: json['category'] as String,
  action: json['action'] as String,
  resource: json['resource'] as String,
);

Map<String, dynamic> _$PermissionToJson(Permission instance) =>
    <String, dynamic>{
      'permissionId': instance.permissionId,
      'name': instance.name,
      'category': instance.category,
      'action': instance.action,
      'resource': instance.resource,
    };
