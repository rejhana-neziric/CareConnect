import 'package:json_annotation/json_annotation.dart';

part 'permission.g.dart';

@JsonSerializable()
class Permission {
  final int permissionId;
  final String name;
  final String category;
  final String action;
  final String resource;

  Permission({
    required this.permissionId,
    required this.name,
    required this.category,
    required this.action,
    required this.resource,
  });

  factory Permission.fromJson(Map<String, dynamic> json) =>
      _$PermissionFromJson(json);

  Map<String, dynamic> toJson() => _$PermissionToJson(this);
}
