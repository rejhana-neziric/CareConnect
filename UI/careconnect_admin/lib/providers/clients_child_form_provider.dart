import 'package:careconnect_admin/models/requests/child_insert_request.dart';
import 'package:careconnect_admin/models/requests/client_insert_request.dart';
import 'package:careconnect_admin/models/requests/client_update_request.dart';
import 'package:careconnect_admin/models/requests/clients_child_insert_request.dart';
import 'package:careconnect_admin/models/requests/clients_child_update_request.dart';
import 'package:careconnect_admin/models/requests/user_insert_request.dart';
import 'package:careconnect_admin/models/requests/user_update_request.dart';
import 'package:careconnect_admin/providers/base_form_provider.dart';
import 'package:careconnect_admin/providers/clients_child_provider.dart';
import 'package:flutter/material.dart';

class ClientsChildFormProvider
    extends BaseFormProvider<ClientsChildFormProvider, ClientsChildProvider> {
  Future<bool> saveOrUpdateCustom(
    ClientsChildFormProvider clientsChildFormProvider,
    ClientsChildProvider clientsChildProvider,
    int? clientId,
    int? childId,
    bool isAccessAllowed,
  ) async {
    try {
      final formData = clientsChildFormProvider.formKey.currentState?.value;

      if (formData == null) {
        return false;
      }

      if (!clientsChildFormProvider.isUpdate) {
        final insertRequest = ClientsChildInsertRequest(
          clientInsertRequest: ClientInsertRequest(
            employmentStatus: formData['employmentStatus'],
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
          ),
          childInsertRequest: ChildInsertRequest(
            firstName: formData['childFirstName'],
            lastName: formData['childLastName'],
            birthDate: formData['childBirthDate'],
            gender: formData['childGender'],
          ),
        );

        await clientsChildProvider.insert(insertRequest);
      } else {
        final updateRequest = ClientsChildUpdateRequest(
          clientUpdateRequest: ClientUpdateRequest(
            employmentStatus: formData['employmentStatus'],
            user: UserUpdateRequest(
              firstName: formData['firstName'],
              lastName: formData['lastName'],
              phoneNumber: formData['phoneNumber'],
              username: formData['username'],
              status: isAccessAllowed,
              address: formData['address'],
              password: formData['password'],
              confirmationPassword: formData['confirmationPassword'],
              email: formData['email'],
            ),
          ),
        );

        if (clientId != null && childId != null) {
          await clientsChildProvider.updateComposite(
            clientId,
            childId,
            updateRequest,
          );
        }
      }

      notifyListeners();

      return true;
    } catch (e) {
      debugPrint("Error: $e");
      return false;
    }
  }

  Future<bool> addChild(
    ClientsChildFormProvider clientsChildFormProvider,
    ClientsChildProvider clientsChildProvider,
    int? clientId, {
    VoidCallback? onSaved,
  }) async {
    try {
      final formData = clientsChildFormProvider.formKey.currentState?.value;

      if (formData == null || clientId == null) {
        return false;
      }

      final insertRequest = ChildInsertRequest(
        firstName: formData['childFirstName'],
        lastName: formData['childLastName'],
        birthDate: formData['childBirthDate'],
        gender: formData['childGender'],
      );

      await clientsChildProvider.addChildToClient(clientId, insertRequest);

      onSaved?.call();

      return true;
    } catch (e) {
      debugPrint("Error: $e");
      return false;
    }
  }
}
