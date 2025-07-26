import 'dart:convert';

import 'package:careconnect_admin/models/responses/employee.dart';
import 'package:careconnect_admin/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class EmployeeProvider extends BaseProvider<Employee> {
  EmployeeProvider() : super("Employee");

  @override
  Employee fromJson(data) {
    return Employee.fromJson(data);
  }

  @override
  int? getId(Employee item) {
    return item.user?.userId;
  }

  Future<dynamic> getStatistics() async {
    var url = "${baseUrl}$endpoint/statistics";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      notifyListeners();

      print(data);

      return data;
    } else {
      throw new Exception("Unknown error");
    }
  }
}
