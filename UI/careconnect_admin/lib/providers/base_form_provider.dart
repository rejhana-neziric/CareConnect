import 'package:careconnect_admin/widgets/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:collection/collection.dart';

abstract class BaseFormProvider<TFormProvider, TEntityProvider>
    with ChangeNotifier {
  GlobalKey<FormBuilderState> formKey;

  BaseFormProvider() : formKey = GlobalKey<FormBuilderState>();

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

  void setForUpdate(Map<String, dynamic> data) {
    isUpdate = true;
    initialData = Map<String, dynamic>.from(data);
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

  bool? success;

  void saveInitialValue() {
    final currentRaw = formKey.currentState?.value ?? {};
    initialData = removeNulls(currentRaw);
  }

  Map<String, dynamic> removeNulls(Map<String, dynamic> map) {
    final cleaned = <String, dynamic>{};
    map.forEach((key, value) {
      if (value != null) cleaned[key] = value;
    });
    return cleaned;
  }

  bool get hasUnsavedChanges {
    formKey.currentState?.save();
    final current = removeNulls(formKey.currentState?.value ?? {});
    final normalizedInitial = removeNulls(initialData);
    return !const DeepCollectionEquality().equals(current, normalizedInitial);
  }

  Future<bool> handleBackPressed(BuildContext context) async {
    success = await canExit(context, hasUnsavedChanges);
    return success ?? true;
  }

  Future<bool> canExit(BuildContext context, bool hasUnsaved) async {
    if (hasUnsaved) {
      final confirm = await CustomConfirmDialog.show(
        context,
        icon: Icons.warning_amber_outlined,
        title: 'Unsaved changes',
        content: 'You have unsaved changes. Exit anyway?',
        confirmText: 'Yes',
        cancelText: 'Cancel',
      );

      return confirm;
    }
    return true;
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
      return 'Password must not exceed 32 characters.';
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

  String? validateServicWorkshopeName(String? value) {
    if (value == null || value.trim().isEmpty) return 'This fiels is required.';
    if (value.length < 3) return 'Name must be at least 3 characters.';
    if (value.length > 100) {
      return 'Name must not exceed 100 characters.';
    }
    return null;
  }

  String? validateDescription(String? value) {
    if (value != null && value.trim().isNotEmpty) {
      if (value.length > 300) {
        return 'Description must not exceed 300 characters.';
      }
    }
    return null;
  }

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

  Future<bool> saveOrUpdate(
    TFormProvider formProvider,
    TEntityProvider entitiyProvider,
    int? id,
  ) async {
    throw Exception("Method not implemented");
  }

  void resetForm() {
    formKey = GlobalKey<FormBuilderState>();
    notifyListeners();
  }
}
