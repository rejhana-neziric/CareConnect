import 'package:careconnect_admin/models/responses/role.dart';
import 'package:careconnect_admin/providers/base_provider.dart';

class RoleProvider extends BaseProvider<Role> {
  RoleProvider() : super("Role");

  @override
  Role fromJson(data) {
    return Role.fromJson(data);
  }

  @override
  int? getId(Role item) {
    return item.roleId;
  }
}
