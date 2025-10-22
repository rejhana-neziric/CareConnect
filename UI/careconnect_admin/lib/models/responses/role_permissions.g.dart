// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_permissions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RolePermissions _$RolePermissionsFromJson(Map<String, dynamic> json) =>
    RolePermissions(
      role: Role.fromJson(json['role'] as Map<String, dynamic>),
      allPermissions: (json['allPermissions'] as List<dynamic>)
          .map((e) => Permission.fromJson(e as Map<String, dynamic>))
          .toList(),
      assignedPermissions: (json['assignedPermissions'] as List<dynamic>)
          .map((e) => Permission.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RolePermissionsToJson(RolePermissions instance) =>
    <String, dynamic>{
      'role': instance.role,
      'allPermissions': instance.allPermissions,
      'assignedPermissions': instance.assignedPermissions,
    };
