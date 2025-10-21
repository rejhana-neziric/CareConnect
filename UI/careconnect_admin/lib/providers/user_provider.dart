import 'dart:convert';
import 'package:careconnect_admin/models/auth_credentials.dart';
import 'package:careconnect_admin/models/responses/user.dart';
import 'package:careconnect_admin/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class UserProvider extends BaseProvider<User> {
  UserProvider() : super("User");

  @override
  User fromJson(data) {
    return User.fromJson(data);
  }

  @override
  int? getId(User item) {
    return item.userId;
  }

  Future<User?> login(String username, String password) async {
    AuthCredentials.username = username;
    AuthCredentials.password = password;

    var url = "$baseUrl$endpoint/login?username=$username&password=$password";
    var uri = Uri.parse(url);

    var response = await http.post(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data);
    }
    return null;
  }

  Future<List<String>> getPermission(String username) async {
    var url = "$baseUrl$endpoint/permissions?username=$username";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      List<String> result = [];

      // result = data;

      for (var item in data) {
        result.add(item as String);
        // _items = result;
      }

      notifyListeners();
      print(result);
      return result;
    } else {
      throw new Exception("Unknown error");
    }
  }

  Future<bool> changePassword({
    required int userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint/change-password');

    final body = jsonEncode({
      'userId': userId,
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    });

    var headers = createHeaders();

    final response = await http.post(url, headers: headers, body: body);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      return false;
    }
  }
}
