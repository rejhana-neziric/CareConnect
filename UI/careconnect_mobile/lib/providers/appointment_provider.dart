import 'dart:convert';

import 'package:careconnect_mobile/models/requests/appointment_insert_request.dart';
import 'package:careconnect_mobile/models/responses/appointment.dart';
import 'package:careconnect_mobile/models/responses/search_result.dart';
import 'package:careconnect_mobile/models/search_objects/appointment_additional_data.dart';
import 'package:careconnect_mobile/models/search_objects/appointment_search_object.dart';
import 'package:careconnect_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class AppointmentProvider extends BaseProvider<Appointment> {
  AppointmentProvider() : super("Appointment");

  @override
  Appointment fromJson(data) {
    return Appointment.fromJson(data);
  }

  @override
  int? getId(Appointment item) {
    return item.appointmentId;
  }

  Future<SearchResult<Appointment>?> loadData({
    String? fts,
    String? appointmentType,
    DateTime? dateGTE,
    DateTime? dateLTE,
    String? attendanceStatusName,
    String? employeeFirstName,
    String? employeeLastName,
    String? childFirstName,
    String? childLastName,
    String? startTime,
    String? endTime,
    String? status,
    int? clientId,
    int? childId,
    int? serviceTypeId,
    String? clientUsername,
    String? serviceNameGTE,
    // String? userFirstNameGTE;
    // String? userLastNameGTE;
    int page = 0,
    String? sortBy,
    bool sortAscending = true,
  }) async {
    final filterObject = AppointmentSearchObject(
      fts: fts,
      appointmentType: appointmentType,
      dateGTE: dateGTE,
      dateLTE: dateLTE,
      attendanceStatusName: attendanceStatusName,
      employeeFirstName: employeeFirstName,
      employeeLastName: employeeLastName,
      childFirstName: childFirstName,
      childLastName: childLastName,
      startTime: startTime,
      endTime: endTime,
      status: status,
      clientId: clientId,
      childId: childId,
      clientUsername: clientUsername,
      serviceTypeId: serviceTypeId,
      serviceNameGTE: serviceNameGTE,
      page: page,
      sortBy: sortBy,
      sortAscending: sortAscending,
      additionalData: AppointmentAdditionalData(
        isClientsChildIncluded: true,
        isAttendanceStatusIncluded: true,
        isEmployeeAvailabilityIncluded: true,
      ),
      includeTotalCount: true,
    );

    final filter = filterObject.toJson();

    final result = await get(filter: filter);

    notifyListeners();
    return result;
  }

  Future<List<String>> getAppoinmentTypes() async {
    var url = "$baseUrl$endpoint/appointment-types";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      List<String> result = [];

      for (var item in data) {
        result.add(item.toString());
      }

      return result;
    } else {
      throw new Exception("Unknown error");
    }
  }

  Future<Appointment?> scheduleAppointment(
    AppointmentInsertRequest request,
  ) async {
    var url = "$baseUrl$endpoint";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(request.toJson()),
    );

    if (isValidResponse(response)) {
      if (response.body.isNotEmpty && response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return Appointment.fromJson(data);
      } else {
        return null;
      }
    } else {
      throw Exception("Failed to schedule appointment");
    }
  }
}
