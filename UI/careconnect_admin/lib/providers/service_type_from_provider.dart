import 'package:careconnect_admin/models/requests/service_type_insert_request.dart';
import 'package:careconnect_admin/models/requests/service_type_update_request.dart';
import 'package:careconnect_admin/providers/base_form_provider.dart';
import 'package:careconnect_admin/providers/service_type_provider.dart';
import 'package:flutter/material.dart';

class ServiceTypeFromProvider
    extends BaseFormProvider<ServiceTypeFromProvider, ServiceTypeProvider> {
  @override
  Future<bool> saveOrUpdate(
    ServiceTypeFromProvider formProvider,
    ServiceTypeProvider entitiyProvider,
    int? id,
  ) async {
    try {
      final formData = formProvider.formKey.currentState?.value;

      if (formData == null) {
        return false;
      }

      if (!formProvider.isUpdate) {
        final insertRequest = ServiceTypeInsertRequest(
          name: formData['name'],
          description: formData['description'],
        );

        await entitiyProvider.insert(insertRequest);
      } else {
        final updateRequest = ServiceTypeUpdateRequest(
          name: formData['name'],
          description: formData['description'],
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
