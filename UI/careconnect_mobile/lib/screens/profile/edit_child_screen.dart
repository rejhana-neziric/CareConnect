import 'package:careconnect_mobile/core/theme/app_colors.dart';
import 'package:careconnect_mobile/models/requests/child_insert_request.dart';
import 'package:careconnect_mobile/models/requests/child_update_request.dart';
import 'package:careconnect_mobile/models/responses/child.dart';
import 'package:careconnect_mobile/widgets/confim_dialog.dart';
import 'package:careconnect_mobile/widgets/custom_date_field.dart';
import 'package:careconnect_mobile/widgets/custom_text_field.dart';
import 'package:careconnect_mobile/widgets/primary_button.dart';
import 'package:careconnect_mobile/widgets/snackbar.dart';
import 'package:flutter/material.dart';

class EditChildScreen extends StatefulWidget {
  final Child? child;
  final Function(ChildUpdateRequest)? onChildUpdated;
  final Function(ChildInsertRequest)? onChildInserted;

  const EditChildScreen({
    super.key,
    this.child,
    this.onChildUpdated,
    this.onChildInserted,
  });

  @override
  State<EditChildScreen> createState() => _EditChildScreenState();
}

class _EditChildScreenState extends State<EditChildScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _selectedGender = 'M';

  late bool isEditing;

  final Map<String, String> _genderOptions = {'M': 'Male', 'F': 'Female'};

  @override
  void initState() {
    super.initState();

    isEditing = widget.child == null ? false : true;

    if (isEditing && widget.child != null) {
      _firstNameController.text = widget.child!.firstName;
      _lastNameController.text = widget.child!.lastName;
      _selectedDate = widget.child!.birthDate;
      _selectedGender = widget.child!.gender;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLow,
      appBar: AppBar(
        backgroundColor: colorScheme.surfaceContainerLow,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        title: Text(
          isEditing ? 'Edit Child' : 'Add New Child',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildFormCard(colorScheme),
              const SizedBox(height: 30),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEditing ? 'Update Information' : 'Child Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 24),
            customTextField(
              controller: _firstNameController,
              label: 'First Name',
              icon: Icons.person_outline_rounded,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'This fiels is required.';
                }
                if (value.length < 2) {
                  return 'Name must be at least 2 characters.';
                }
                if (value.length > 50) {
                  return 'Name must not exceed 50 characters.';
                }
                return null;
              },
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 20),
            customTextField(
              controller: _lastNameController,
              label: 'Last Name',
              icon: Icons.person_outline_rounded,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'This fiels is required.';
                }
                if (value.length < 2) {
                  return 'Name must be at least 2 characters.';
                }
                if (value.length > 50) {
                  return 'Name must not exceed 50 characters.';
                }
                return null;
              },
              colorScheme: colorScheme,
            ),
            const SizedBox(height: 20),
            CustomDateField(
              label: "Birth Date",
              initialDate: _selectedDate,
              onDateSelected: (date) {
                setState(() {
                  if (date != null) _selectedDate = date;
                });
              },
              validator: (date) {
                if (date == null) {
                  return "Birth date is required";
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            if (!isEditing) _buildGenderDropdown(colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderDropdown(ColorScheme colorScheme) {
    return DropdownButtonFormField<String>(
      value: _selectedGender,
      decoration: InputDecoration(
        enabled: false,
        labelText: 'Gender',
        prefixIcon: Icon(Icons.wc, color: colorScheme.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primaryContainer, width: 2),
        ),
        filled: true,
        fillColor: colorScheme.surfaceContainerLow,
      ),
      items: _genderOptions.entries.map((entry) {
        return DropdownMenuItem<String>(
          value: entry.key,
          child: Text(entry.value),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedGender = value!;
        });
      },
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        PrimaryButton(
          label: 'Save',
          isLoading: false,
          type: ButtonType.filled,
          onPressed: _save,
        ),
        const SizedBox(height: 12),
        PrimaryButton(
          label: 'Cancel',
          type: ButtonType.outlined,
          backgroundColor: colorScheme.onSurface,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      debugPrint('Form is not valid or state is null');
      return;
    }

    final shouldProceed = await CustomConfirmDialog.show(
      context,
      iconBackgroundColor: AppColors.accentDeepMauve,
      icon: Icons.info,
      title: isEditing ? 'Edit' : 'Add',
      content: isEditing
          ? 'Are you sure you want to save changes?'
          : 'Are you sure you want to add new child?',
      confirmText: 'Save',
      cancelText: 'Cancel',
    );

    if (shouldProceed != true) return;

    if (mounted) {
      setState(() {});
    }
    try {
      final request = isEditing
          ? ChildUpdateRequest(
              firstName: _firstNameController.text,
              lastName: _lastNameController.text,
              birthDate: _selectedDate,
            )
          : ChildInsertRequest(
              firstName: _firstNameController.text,
              lastName: _lastNameController.text,
              birthDate: _selectedDate,
              gender: _selectedGender,
            );

      if (isEditing) {
        widget.onChildUpdated!(request as ChildUpdateRequest);
      } else {
        widget.onChildInserted!(request as ChildInsertRequest);
      }

      if (mounted) {
        CustomSnackbar.show(
          context,
          message: isEditing
              ? 'Child information updated successfully!'
              : 'Successfully added new child!',
          type: SnackbarType.success,
        );

        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar.show(
          context,
          message: 'Something went wrong. Please try again.',
          type: SnackbarType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          // _isLoading = false;
        });
      }
    }
  }
}
