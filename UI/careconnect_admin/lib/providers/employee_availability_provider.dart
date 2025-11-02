// import 'dart:convert';
import 'package:careconnect_admin/models/responses/employee_availability.dart';
import 'package:careconnect_admin/providers/base_provider.dart';

class EmployeeAvailabilityProvider extends BaseProvider<EmployeeAvailability> {
  EmployeeAvailabilityProvider() : super("Employee");

  @override
  EmployeeAvailability fromJson(data) {
    return EmployeeAvailability.fromJson(data);
  }

  @override
  int? getId(EmployeeAvailability item) {
    return item.employeeAvailabilityId;
  }
}
