// import 'dart:convert';
import 'package:careconnect_mobile/models/responses/employee_availability.dart';
import 'package:careconnect_mobile/models/responses/search_result.dart';
import 'package:careconnect_mobile/models/search_objects/employee_availability_additional_data.dart';
import 'package:careconnect_mobile/models/search_objects/employee_availability_search_object.dart';
import 'package:careconnect_mobile/providers/base_provider.dart';
// import 'package:http/http.dart' as http;

class EmployeeAvailabilityProvider extends BaseProvider<EmployeeAvailability> {
  EmployeeAvailabilityProvider() : super("EmployeeAvailability");

  @override
  EmployeeAvailability fromJson(data) {
    return EmployeeAvailability.fromJson(data);
  }

  @override
  int? getId(EmployeeAvailability item) {
    return item.employeeAvailabilityId;
  }

  Future<SearchResult<EmployeeAvailability>?> loadData({
    String? fts,
    int? employeeId,
    int? serviceId,
    bool? employed,
    int page = 0,
    String? sortBy,
    bool sortAscending = true,
  }) async {
    final filterObject = EmployeeAvailabilitySearchObject(
      fts: fts,
      employeeId: employeeId,
      serviceId: serviceId,
      page: page,
      sortBy: sortBy,
      sortAscending: sortAscending,
      additionalData: EmployeeAvailabilityAdditionalData(
        isEmployeeIncluded: true,
      ),
      includeTotalCount: true,
    );

    final filter = filterObject.toJson();

    final result = await get(filter: filter);

    notifyListeners();
    return result;
  }
}
