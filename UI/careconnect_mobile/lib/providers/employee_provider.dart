import 'dart:convert';

import 'package:careconnect_mobile/models/responses/employee.dart';
import 'package:careconnect_mobile/models/responses/employee_availability.dart';
import 'package:careconnect_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class EmployeeProvider extends BaseProvider<Employee> {
  EmployeeProvider() : super("Employee");

  @override
  Employee fromJson(data) {
    return Employee.fromJson(data);
  }

  // Future<List<EmployeeAvailability>> getEmployeeAvailability(
  //   int employeeId,
  // ) async {
  //   var url = "$baseUrl$endpoint/$employeeId/availability";
  //   var uri = Uri.parse(url);
  //   var headers = createHeaders();

  //   var response = await http.get(uri, headers: headers);

  //   if (isValidResponse(response)) {
  //     if (response.body.isNotEmpty) {
  //       var data = jsonDecode(response.body);

  //       List<EmployeeAvailability> result = [];

  //       for (var item in data) {
  //         result.add(EmployeeAvailability.fromJson(item));
  //       }

  //       notifyListeners();

  //       return result;
  //     } else {
  //       return [];
  //     }
  //   } else {
  //     throw new Exception("Unknown error");
  //   }
  // }

  Future<List<EmployeeAvailability>> getEmployeeAvailability(
    int employeeId, {
    DateTime? date,
  }) async {
    // Build URL with optional query parameter
    var url = "$baseUrl$endpoint/$employeeId/availability";
    if (date != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      url += "?date=$formattedDate";
    }

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      if (response.body.isNotEmpty) {
        var data = jsonDecode(response.body) as List;

        List<EmployeeAvailability> result = data
            .map((item) => EmployeeAvailability.fromJson(item))
            .toList();

        notifyListeners();

        return result;
      } else {
        return [];
      }
    } else {
      throw Exception("Unknown error");
    }
  }
}
