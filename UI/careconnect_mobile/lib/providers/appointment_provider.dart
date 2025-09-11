import 'package:careconnect_mobile/models/responses/appointment.dart';
import 'package:careconnect_mobile/models/responses/search_result.dart';
import 'package:careconnect_mobile/models/search_objects/appointment_additional_data.dart';
import 'package:careconnect_mobile/models/search_objects/appointment_search_object.dart';
import 'package:careconnect_mobile/providers/base_provider.dart';

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
}
