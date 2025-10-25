import 'package:careconnect_admin/models/requests/employee_insert_request.dart';
import 'package:careconnect_admin/models/requests/employee_update_request.dart';
import 'package:careconnect_admin/models/requests/qualification_insert_request.dart';
import 'package:careconnect_admin/models/requests/qualification_update_request.dart';
import 'package:careconnect_admin/models/requests/user_insert_request.dart';
import 'package:careconnect_admin/models/requests/user_update_request.dart';
import 'package:careconnect_admin/providers/base_form_provider.dart';
import 'package:careconnect_admin/providers/employee_provider.dart';
import 'package:flutter/material.dart';

class EmployeeFormProvider
    extends BaseFormProvider<EmployeeFormProvider, EmployeeProvider> {
  Future<bool> saveOrUpdateCustom(
    EmployeeFormProvider formProvider,
    EmployeeProvider entitiyProvider,
    int? id,
    bool isAccessAllowed,
  ) async {
    try {
      final formData = formProvider.formKey.currentState?.value;

      if (formData == null) {
        return false;
      }

      if (!formProvider.isUpdate) {
        final insertRequest = EmployeeInsertRequest(
          hireDate: formData['hireDate'],
          jobTitle: formData['jobTitle'],
          user: UserInsertRequest(
            firstName: formData['firstName'],
            lastName: formData['lastName'],
            email: formData['email'],
            phoneNumber: formData['phoneNumber'],
            username: formData['username'],
            password: formData['password'],
            confirmationPassword: formData['confirmationPassword'],
            birthDate: formData['birthDate'],
            gender: formData['gender'],
            address: formData['address'],
          ),
          qualification: QualificationInsertRequest(
            name: formData['qualificationName'],
            instituteName: formData['qualificationInstituteName'],
            procurementYear: formData['qualificationProcurementYear'],
          ),
        );

        await entitiyProvider.insert(insertRequest);
      } else {
        final updateRequest = EmployeeUpdateRequest(
          jobTitle: formData['jobTitle'],
          endDate: formData['endDate'],
          user: UserUpdateRequest(
            phoneNumber: formData['phoneNumber'],
            username: formData['username'],
            status: isAccessAllowed,
            address: formData['address'],
            password: formData['password'],
            confirmationPassword: formData['confirmationPassword'],
            email: formData['email'],
          ),
          qualification: QualificationUpdateRequest(
            name: formData['qualificationName'],
            instituteName: formData['qualificationInstituteName'],
            procurementYear: formData['qualificationProcurementYear'],
          ),
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
