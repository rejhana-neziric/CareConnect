import 'package:careconnect_admin/models/requests/user_insert_request.dart';
import 'package:careconnect_admin/models/requests/user_update_request.dart';
import 'package:careconnect_admin/providers/base_form_provider.dart';
import 'package:careconnect_admin/providers/user_provider.dart';
import 'package:flutter/material.dart';

class UserFormProvider
    extends BaseFormProvider<UserFormProvider, UserProvider> {
  @override
  Future<bool> saveOrUpdate(
    UserFormProvider formProvider,
    UserProvider entitiyProvider,
    int? id,
  ) async {
    try {
      final formData = formProvider.formKey.currentState?.value;

      if (formData == null) {
        return false;
      }

      if (!formProvider.isUpdate) {
        final insertRequest = UserInsertRequest(
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
        );

        await entitiyProvider.insert(insertRequest);
      } else {
        final updateRequest = UserUpdateRequest(
          phoneNumber: formData['phoneNumber'],
          username: formData['username'],
          status: formData['status'],
          address: formData['address'],
          password: formData['password'],
          confirmationPassword: formData['confirmationPassword'],
          email: formData['email'],
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
