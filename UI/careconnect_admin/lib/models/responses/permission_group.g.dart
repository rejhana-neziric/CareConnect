// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PermissionGroup _$PermissionGroupFromJson(Map<String, dynamic> json) =>
    PermissionGroup(
      category: json['category'] as String,
      permissions: (json['permissions'] as List<dynamic>)
          .map((e) => Permission.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PermissionGroupToJson(PermissionGroup instance) =>
    <String, dynamic>{
      'category': instance.category,
      'permissions': instance.permissions,
    };
