import 'dart:convert';
import 'package:careconnect_admin/models/responses/appointment.dart';
import 'package:careconnect_admin/models/responses/search_result.dart';
import 'package:careconnect_admin/models/search_objects/appointment_additional_data.dart';
import 'package:careconnect_admin/models/search_objects/appointment_search_object.dart';
import 'package:careconnect_admin/providers/base_provider.dart';
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

  Future<bool> _updateAppointmentStatus({
    required int appointmentId,
    required String actionPath,
  }) async {
    final url = '$baseUrl$endpoint/$appointmentId/$actionPath';
    final uri = Uri.parse(url);
    final headers = createHeaders();

    final response = await http.put(uri, headers: headers);

    if (isValidResponse(response)) {
      final data = jsonDecode(response.body);
      final updated = fromJson(data);
      final index = item.result.indexWhere((e) => getId(e) == appointmentId);
      if (index != -1) {
        item.result[index] = updated;
        notifyListeners();
      }
      return true;
    }

    return false;
  }

  Future<bool> confirmAppointment({required int appointmentId}) {
    return _updateAppointmentStatus(
      appointmentId: appointmentId,
      actionPath: 'confirm',
    );
  }

  Future<bool> requestReschedule({required int appointmentId}) {
    return _updateAppointmentStatus(
      appointmentId: appointmentId,
      actionPath: 'request-reschedule',
    );
  }

  Future<bool> cancelAppointment({required int appointmentId}) {
    return _updateAppointmentStatus(
      appointmentId: appointmentId,
      actionPath: 'cancel',
    );
  }

  Future<bool> startAppointment({required int appointmentId}) {
    return _updateAppointmentStatus(
      appointmentId: appointmentId,
      actionPath: 'start',
    );
  }

  Future<bool> completeAppointment({required int appointmentId}) {
    return _updateAppointmentStatus(
      appointmentId: appointmentId,
      actionPath: 'complete',
    );
  }

  Future<bool> rescheduleAppointmet({required int appointmentId}) {
    return _updateAppointmentStatus(
      appointmentId: appointmentId,
      actionPath: 'reschedule',
    );
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
}
