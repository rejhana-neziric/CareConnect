import 'dart:convert';

import 'package:careconnect_admin/models/responses/employee.dart';
import 'package:careconnect_admin/models/responses/search_result.dart';
import 'package:careconnect_admin/models/search_objects/employee_additional_data.dart';
import 'package:careconnect_admin/models/search_objects/employee_search_object.dart';
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
    var url = "$baseUrl$endpoint/statistics";
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

  Future<SearchResult<Employee>?> loadData({
    String? fts,
    String? firstNameGTE,
    String? lastNameGTE,
    String? email,
    String? jobTitle,
    DateTime? hireDateGTE,
    DateTime? hireDateLTE,
    bool? employed,
    int page = 0,
    String? sortBy,
    bool sortAscending = true,
  }) async {
    final filterObject = EmployeeSearchObject(
      fts: fts,
      firstNameGTE: firstNameGTE,
      lastNameGTE: lastNameGTE,
      email: email,
      jobTitle: jobTitle,
      hireDateGTE: hireDateGTE,
      hireDateLTE: hireDateLTE,
      employed: employed,
      page: page,
      sortBy: sortBy,
      sortAscending: sortAscending,
      additionalData: EmployeeAdditionalData(
        isUserIncluded: true,
        isQualificationIncluded: true,
      ),
      includeTotalCount: true,
    );

    final filter = filterObject.toJson();

    final result = await get(filter: filter);

    notifyListeners();
    return result;
  }
}
