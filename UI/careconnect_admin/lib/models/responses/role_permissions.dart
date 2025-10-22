import 'package:careconnect_admin/models/responses/permission.dart';
import 'package:careconnect_admin/models/responses/role.dart';
import 'package:json_annotation/json_annotation.dart';

part 'role_permissions.g.dart';

@JsonSerializable()
class RolePermissions {
  final Role role;
  final List<Permission> allPermissions;
  final List<Permission> assignedPermissions;

  RolePermissions({
    required this.role,
    required this.allPermissions,
    required this.assignedPermissions,
  });

  factory RolePermissions.fromJson(Map<String, dynamic> json) =>
      _$RolePermissionsFromJson(json);

  Map<String, dynamic> toJson() => _$RolePermissionsToJson(this);
}
