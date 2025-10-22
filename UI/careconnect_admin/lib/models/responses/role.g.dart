// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Role _$RoleFromJson(Map<String, dynamic> json) => Role(
  roleId: (json['roleId'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String?,
  userCount: (json['userCount'] as num).toInt(),
  permissionIds: (json['permissionIds'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
);

Map<String, dynamic> _$RoleToJson(Role instance) => <String, dynamic>{
  'roleId': instance.roleId,
  'name': instance.name,
  'description': instance.description,
  'userCount': instance.userCount,
  'permissionIds': instance.permissionIds,
};
