import 'package:careconnect_admin/models/responses/permission.dart';
import 'package:json_annotation/json_annotation.dart';

part 'permission_group.g.dart';

@JsonSerializable()
class PermissionGroup {
  final String category;
  final List<Permission> permissions;

  PermissionGroup({required this.category, required this.permissions});

  factory PermissionGroup.fromJson(Map<String, dynamic> json) =>
      _$PermissionGroupFromJson(json);

  Map<String, dynamic> toJson() => _$PermissionGroupToJson(this);
}
