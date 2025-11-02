import 'package:careconnect_admin/models/requests/service_insert_request.dart';
import 'package:careconnect_admin/models/requests/service_update_request.dart';
import 'package:careconnect_admin/providers/base_form_provider.dart';
import 'package:careconnect_admin/providers/service_provider.dart';
import 'package:flutter/material.dart';

class ServiceFormProvider
    extends BaseFormProvider<ServiceFormProvider, ServiceProvider> {
  @override
  Future<bool> saveOrUpdate(
    ServiceFormProvider formProvider,
    ServiceProvider entitiyProvider,
    int? id,
  ) async {
    try {
      final formData = formProvider.formKey.currentState?.value;

      if (formData == null) {
        return false;
      }

      if (!formProvider.isUpdate) {
        final insertRequest = ServiceInsertRequest(
          name: formData['name'],
          description: formData['description'],
          price:
              formData['price'] == null || formData['price'].toString().isEmpty
              ? null
              : double.tryParse(formData['price']),
          isActive: formData['isActive'],
          serviceTypeId: formData['serviceTypeId'],
        );

        await entitiyProvider.insert(insertRequest);
      } else {
        final updateRequest = ServiceUpdateRequest(
          name: formData['name'],
          description: formData['description'],
          price:
              formData['price'] == null || formData['price'].toString().isEmpty
              ? null
              : double.tryParse(formData['price']),
          isActive: formData['isActive'],
          serviceTypeId: formData['serviceTypeId'],
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
