// services/role_permission_service.dart
import 'dart:convert';
import 'package:careconnect_admin/models/responses/permission.dart';
import 'package:careconnect_admin/models/responses/permission_group.dart';
import 'package:careconnect_admin/models/responses/role.dart';
import 'package:careconnect_admin/models/responses/role_permissions.dart';
import 'package:careconnect_admin/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class RolePermissionsProvider extends BaseProvider<RolePermissions> {
  RolePermissionsProvider() : super("RolePermissions");

  @override
  RolePermissions fromJson(data) {
    return RolePermissions.fromJson(data);
  }

  Future<List<Role>> getRoles() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint/roles'),
        headers: createHeaders(),
      );

      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Role.fromJson(json)).toList();
    } on Exception catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Permission>> getPermissions() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint/permissions'),
        headers: createHeaders(),
      );

      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Permission.fromJson(json)).toList();
    } on Exception catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<PermissionGroup>> getGroupedPermissions() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint/permissions/grouped'),
        headers: createHeaders(),
      );

      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => PermissionGroup.fromJson(json)).toList();
    } on Exception catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<RolePermissions> getRolePermissions(int roleId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint/role/$roleId'),
        headers: createHeaders(),
      );

      return RolePermissions.fromJson(json.decode(response.body));
    } on Exception catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> updateRolePermissions(
    int roleId,
    List<int> permissionIds,
  ) async {
    try {
      await http.put(
        Uri.parse('$baseUrl$endpoint/role/$roleId'),
        headers: createHeaders(),

        body: json.encode({'roleId': roleId, 'permissionIds': permissionIds}),
      );
    } on Exception catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<bool> checkConnection() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl$endpoint/roles'), headers: createHeaders())
          .timeout(const Duration(seconds: 5));

      return response.statusCode >= 200 && response.statusCode < 500;
    } catch (e) {
      return false;
    }
  }
}
