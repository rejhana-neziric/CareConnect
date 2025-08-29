import 'package:careconnect_admin/models/requests/employee_availability_insert_request.dart';
import 'package:careconnect_admin/models/requests/employee_availability_update_request.dart';
import 'package:careconnect_admin/providers/base_form_provider.dart';
import 'package:careconnect_admin/providers/employee_availability_provider.dart';
import 'package:flutter/material.dart';

class EmployeeFormAvailabilityProvider
    extends
        BaseFormProvider<
          EmployeeFormAvailabilityProvider,
          EmployeeAvailabilityProvider
        > {
  @override
  Future<bool> saveOrUpdate(
    EmployeeFormAvailabilityProvider formProvider,
    EmployeeAvailabilityProvider entitiyProvider,
    int? id,
  ) async {
    try {
      final formData = formProvider.formKey.currentState?.value;

      if (formData == null) {
        return false;
      }

      if (!formProvider.isUpdate) {
        final insertRequest = EmployeeAvailabilityInsertRequest(
          employeeId: formData['employeeId'],
          dayOfWeek: formData['dayOfWeek'],
          startTime: formData['startTime'],
          endTime: formData['endTime'],
          serviceId: formData['serviceId'],
        );

        await entitiyProvider.insert(insertRequest);
      } else {
        final updateRequest = EmployeeAvailabilityUpdateRequest(
          dayOfWeek: formData['dayOfWeek'],
          startTime: formData['startTime'],
          endTime: formData['endTime'],
          serviceId: formData['serviceId'],
        );

        if (id != null) await entitiyProvider.update(id, updateRequest);
      }

      notifyListeners();

      return true;
    } catch (e) {
      debugPrint("Error: $e");
      return false;
    }
  }
}
