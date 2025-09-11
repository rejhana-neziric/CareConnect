import 'package:careconnect_mobile/models/auth_user.dart';
import 'package:flutter/cupertino.dart';

class AuthProvider extends ChangeNotifier {
  AuthUser? _user;

  AuthUser? get user => _user;

  void setUser(AuthUser user) {
    _user = user;
    notifyListeners();
  }

  bool hasRoles(String role) {
    return _user?.roles.contains(role) ?? false;
  }

  bool hasPermission(String permission) {
    return _user?.permissions.contains(permission) ?? false;
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
