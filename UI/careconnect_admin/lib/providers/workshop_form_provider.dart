import 'package:careconnect_admin/models/requests/workshop_insert_request.dart';
import 'package:careconnect_admin/models/requests/workshop_update_request.dart';
import 'package:careconnect_admin/providers/base_form_provider.dart';
import 'package:careconnect_admin/providers/workshop_provider.dart';
import 'package:flutter/material.dart';

class WorkshopFormProvider
    extends BaseFormProvider<WorkshopFormProvider, WorkshopProvider> {
  String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final trimmed = value.trim();

    final priceRegex = RegExp(r'^\d+(\.\d{1,2})?$');

    if (!priceRegex.hasMatch(trimmed)) {
      return 'Enter a valid price (e.g., 123 or 123.45).';
    }

    final price = double.tryParse(trimmed);
    if (price == null) {
      return 'Price must be a number.';
    }

    if (price < 0) {
      return 'Price cannot be negative.';
    }

    return null;
  }

  String? validateServiceName(String? value) {
    if (value == null || value.trim().isEmpty) return 'This fiels is required.';
    if (value.length < 3) return 'Service Name must be at least 3 characters.';
    if (value.length > 100) {
      return 'Service Name must not exceed 100 characters.';
    }
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) return 'This fiels is required.';
    if (value.trim().isNotEmpty) {
      if (value.length > 300) {
        return 'Description must not exceed 300 characters.';
      }
    }
    return null;
  }

  String? validateNotes(String? value) {
    if (value != null && value.trim().isNotEmpty) {
      if (value.length > 300) {
        return 'Notes must not exceed 300 characters.';
      }
    }
    return null;
  }

  @override
  Future<bool> saveOrUpdate(
    WorkshopFormProvider formProvider,
    WorkshopProvider entitiyProvider,
    int? id,
  ) async {
    try {
      final formData = formProvider.formKey.currentState?.value;

      if (formData == null) {
        return false;
      }

      if (!formProvider.isUpdate) {
        final insertRequest = WorkshopInsertRequest(
          name: formData['name'],
          description: formData['description'],
          workshopType: formData['workshopType'],
          date: formData['date'],
          price:
              formData['price'] == null || formData['price'].toString().isEmpty
              ? null
              : double.tryParse(formData['price']),
          maxParticipants:
              formData['maxParticipants'] == null ||
                  formData['maxParticipants'].toString().isEmpty
              ? null
              : int.tryParse(formData['maxParticipants']),
          notes: formData['notes'],
        );

        await entitiyProvider.insert(insertRequest);
      } else {
        final updateRequest = WorkshopUpdateRequest(
          name: formData['name'],
          description: formData['description'],
          workshopType: formData['workshopType'],
          date: formData['date'],
          price:
              formData['price'] == null || formData['price'].toString().isEmpty
              ? null
              : double.tryParse(formData['price']),
          maxParticipants:
              formData['maxParticipants'] == null ||
                  formData['maxParticipants'].toString().isEmpty
              ? null
              : int.tryParse(formData['maxParticipants']),
          notes: formData['notes'],
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
