import 'dart:convert';
import 'package:careconnect_admin/models/requests/employee_availability_changes.dart';
import 'package:careconnect_admin/models/requests/employee_availability_insert_request.dart';
import 'package:careconnect_admin/models/requests/employee_availability_update_request.dart';
import 'package:careconnect_admin/models/responses/employee.dart';
import 'package:careconnect_admin/models/responses/employee_availability.dart';
import 'package:careconnect_admin/models/responses/search_result.dart';
import 'package:careconnect_admin/models/search_objects/employee_additional_data.dart';
import 'package:careconnect_admin/models/search_objects/employee_search_object.dart';
import 'package:careconnect_admin/models/time_slot.dart';
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

      return data;
    } else {
      throw Exception("Unknown error");
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
    bool? retrieveAll,
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
      retrieveAll: retrieveAll,
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

  Future<List<EmployeeAvailability>> getEmployeeAvailability(
    int employeeId,
  ) async {
    var url = "$baseUrl$endpoint/$employeeId/availability";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      if (response.body.isNotEmpty) {
        var data = jsonDecode(response.body);

        List<EmployeeAvailability> result = [];

        for (var item in data) {
          result.add(EmployeeAvailability.fromJson(item));
        }

        notifyListeners();

        return result;
      } else {
        return [];
      }
    } else {
      throw new Exception("Unknown error");
    }
  }

  Future<Employee> createEmployeeAvailability(
    int employeeId,
    List<TimeSlot> availability,
  ) async {
    var url = "$baseUrl$endpoint/$employeeId/availability";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    List<EmployeeAvailabilityInsertRequest> request = [];

    for (var element in availability) {
      request.add(element.toInsert(employeeId));
    }

    var jsonRequest = jsonEncode(request);
    var response = await http.post(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      var inserted = fromJson(data);
      item.result.add(inserted);
      notifyListeners();
      return inserted;
    } else {
      throw Exception("Unknown error");
    }
  }

  Future<Employee> updateEmployeeAvailability({
    required int employeeId,

    required Map<int, TimeSlot> currentSlots,
    required Map<int, TimeSlot> originalSlots,
  }) async {
    final changes = _detectChanges(employeeId, currentSlots, originalSlots);

    if (!changes.hasChanges) {
      final current = await getById(employeeId);
      return current;
    }

    var url = "$baseUrl$endpoint/$employeeId/availability";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var request = jsonEncode(changes);

    var response = await http.patch(uri, headers: headers, body: request);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      var updated = fromJson(data);
      var index = item.result.indexWhere((e) => getId(e) == employeeId);
      if (index != -1) {
        item.result[index] = updated;
        notifyListeners();
      }
      return fromJson(data);
    } else {
      throw Exception("Unknown error");
    }
  }

  EmployeeAvailabilityChanges _detectChanges(
    int employeeId,
    Map<int, TimeSlot> current,
    Map<int, TimeSlot> original,
  ) {
    final toCreate = <EmployeeAvailabilityInsertRequest>[];
    final toUpdate = <int, EmployeeAvailabilityUpdateRequest>{};
    final toDelete = <int>[];

    current.forEach((key, slot) {
      if (!original.containsKey(key)) {
        toCreate.add(
          EmployeeAvailabilityInsertRequest.fromTimeSlot(slot, employeeId),
        );
      } else {
        final originalSlot = original[key]!;

        if (('${slot.day}_${slot.start}_${slot.end}' !=
                '${originalSlot.day}_${originalSlot.start}_${originalSlot.end}') ||
            (slot.service?.serviceId.toString() !=
                originalSlot.service?.serviceId.toString())) {
          //fix
          toUpdate.addAll({
            key: EmployeeAvailabilityUpdateRequest.fromTimeSlot(
              slot,
              employeeId,
            ),
          });
        }
      }
    });

    original.forEach((key, slot) {
      if (!current.containsKey(key)) {
        toDelete.add(key);
      }
    });

    return EmployeeAvailabilityChanges(
      toCreate: toCreate,
      toUpdate: toUpdate,
      toDelete: toDelete,
    );
  }
}
