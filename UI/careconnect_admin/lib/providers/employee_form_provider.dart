import 'package:careconnect_admin/models/requests/employee_insert_request.dart';
import 'package:careconnect_admin/models/requests/employee_update_request.dart';
import 'package:careconnect_admin/models/requests/qualification_insert_request.dart';
import 'package:careconnect_admin/models/requests/qualification_update_request.dart';
import 'package:careconnect_admin/models/requests/user_insert_request.dart';
import 'package:careconnect_admin/models/requests/user_update_request.dart';
import 'package:careconnect_admin/providers/employee_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class EmployeeFormProvider with ChangeNotifier {
  GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  bool isUpdate = false;
  Map<String, dynamic> initialData = {};

  void setForInsert() {
    isUpdate = false;
    initialData = {};
    if (formKey.currentState != null) {
      formKey.currentState!.reset();
    }
    notifyListeners();
  }

  void setForUpdate(Map<String, dynamic> employeeData) {
    isUpdate = true;
    initialData = Map<String, dynamic>.from(employeeData);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (formKey.currentState != null) {
        formKey.currentState!.patchValue(initialData);
      }
    });
    notifyListeners();
  }

  void setFormValues(Map<String, dynamic> values) {
    if (formKey.currentState != null) {
      formKey.currentState!.patchValue(values);
    }
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'This fiels is required.';
    if (value.length < 2) return 'Name must be at least 2 characters.';
    if (value.length > 50) return 'Name must not exceed 50 characters.';
    return null;
  }

  String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) return 'Username is required.';
    if (value.length < 4) return 'Username must be at least 4 characters.';
    if (value.length > 20) return 'Username must not exceed 20 characters.';
    return null;
  }

  String? validateEmail(String? value) {
    if (value != null && value.isNotEmpty) {
      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
      if (!emailRegex.hasMatch(value)) return 'Invalid email.';
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (!isUpdate && (value == null || value.isEmpty)) {
      return 'Password is required.';
    }
    if (value != null && value.length < 8) {
      return 'Password must be at least 8 characters.';
    }
    if (value != null && value.length > 32) {
      return 'Password must not exceed 32 characters';
    }
    return null;
  }

  String? validateConfirmationPassword(
    String? value,
    String? originalPassword,
  ) {
    if (!isUpdate && (value == null || value.isEmpty)) {
      return 'Confirmation password is required.';
    }
    if (value != originalPassword) {
      return 'Passwords do not match.';
    }
    return null;
  }

  String? validateAddress(String? value) {
    if (value != null && value.trim().isNotEmpty) {
      if (value.length < 5) return 'Address must be at least 5 characters.';
      if (value.length > 100) return 'Address must not exceed 100 characters.';
    }

    return null;
  }

  String? validatePhoneNumber(String? value) {
    if (value != null && value.trim().isNotEmpty) {
      final digitsOnly = value.trim();

      if (!RegExp(r'^\d+$').hasMatch(digitsOnly)) {
        return 'Phone number must contain digits only.';
      }

      if (digitsOnly.length < 8 || digitsOnly.length > 9) {
        return 'Phone number must be 8 or 9 digits long.';
      }
    }
    return null;
  }

  String? validateDate(DateTime? value) {
    if (value == null) return 'Please select a date.';
    return null;
  }

  String? validateDropdown(dynamic value) {
    if (value == null) return 'Please select a value.';
    return null;
  }

  String? validateNonEmpty(String? value) {
    if (value == null || value.trim().isEmpty) return 'This field is required.';
    return null;
  }

  String? validateNonEmptyBool(bool? value) {
    if (value == null) return 'This field is required.';
    return null;
  }

  Future<bool> saveOrUpdate(
    EmployeeFormProvider employeeFormProvider,
    EmployeeProvider employeeProvider,
    int? id, {
    VoidCallback? onSaved,
  }) async {
    try {
      final formData = employeeFormProvider.formKey.currentState?.value;

      if (formData == null) {
        return false;
      }

      print(formData);
      if (!employeeFormProvider.isUpdate) {
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

        await employeeProvider.insert(insertRequest);
      } else {
        final updateRequest = EmployeeUpdateRequest(
          jobTitle: formData['jobTitle'],
          user: UserUpdateRequest(
            phoneNumber: formData['phoneNumber'],
            username: formData['username'],
            status: formData['status'],
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

        if (id != null) await employeeProvider.update(id, updateRequest);
      }

      onSaved?.call();

      return true;
    } catch (e) {
      debugPrint("Error: $e");
      return false;
    }
  }

  void resetForm() {
    formKey = GlobalKey<FormBuilderState>();
    notifyListeners();
  }
}
