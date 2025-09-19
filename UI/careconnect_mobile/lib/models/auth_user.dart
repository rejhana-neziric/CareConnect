class AuthUser {
  final int id;
  final String username;
  final List<String> roles;
  final List<String> permissions;

  AuthUser({
    required this.id,
    required this.username,
    required this.roles,
    required this.permissions,
  });
}
