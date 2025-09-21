import 'package:careconnect_mobile/core/theme/app_colors.dart';
import 'package:careconnect_mobile/models/requests/child_insert_request.dart';
import 'package:careconnect_mobile/models/requests/child_update_request.dart';
import 'package:careconnect_mobile/models/responses/child.dart';
import 'package:careconnect_mobile/widgets/confim_dialog.dart';
import 'package:careconnect_mobile/widgets/custom_text_field.dart';
import 'package:careconnect_mobile/widgets/primary_button.dart';
import 'package:careconnect_mobile/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

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
  final _formKey = GlobalKey<FormBuilderState>();

  late bool isEditing;

  Map<String, dynamic> _initialValue = {};

  @override
  void initState() {
    super.initState();

    isEditing = widget.child == null ? false : true;

    if (isEditing && widget.child != null) {
      _initialValue = {
        'firstName': widget.child!.firstName,
        'lastName': widget.child!.lastName,
        'birthDate': widget.child!.birthDate,
        'gender': widget.child!.gender,
      };
    }
  }

  @override
  void dispose() {
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
      body: FormBuilder(
        key: _formKey,
        initialValue: _initialValue,
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

            CustomTextField(
              name: 'firstName',
              label: 'First Name',
              icon: Icons.person_outline,
              validators: [
                FormBuilderValidators.required(
                  errorText: 'First name is required',
                ),
                FormBuilderValidators.minLength(
                  2,
                  errorText: 'Name must be at least 2 characters.',
                ),
                FormBuilderValidators.maxLength(
                  50,
                  errorText: 'Name must not exceed 50 characters.',
                ),
              ],
            ),
            const SizedBox(height: 20),

            CustomTextField(
              name: 'lastName',
              label: 'Last Name',
              icon: Icons.person_outline,
              validators: [
                FormBuilderValidators.required(
                  errorText: 'First name is required',
                ),
                FormBuilderValidators.minLength(
                  2,
                  errorText: 'Name must be at least 2 characters.',
                ),
                FormBuilderValidators.maxLength(
                  50,
                  errorText: 'Name must not exceed 50 characters.',
                ),
              ],
            ),
            const SizedBox(height: 20),

            FormBuilderDateTimePicker(
              name: 'birthDate',
              decoration: InputDecoration(
                labelText: 'Birth Date',
                prefixIcon: const Icon(Icons.calendar_today_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              inputType: InputType.date,
              validator: (date) {
                if (date == null) {
                  return "Birth date is required";
                }
                return null;
              },
              format: DateFormat('dd. MM. yyyy'),
            ),

            const SizedBox(height: 20),

            if (!isEditing)
              FormBuilderDropdown<String>(
                name: 'gender',
                decoration: InputDecoration(
                  labelText: 'Gender',
                  prefixIcon: const Icon(Icons.person_outline),
                  prefixIconColor: colorScheme.primary,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: [
                  DropdownMenuItem(value: 'M', child: Text('Male')),
                  DropdownMenuItem(value: 'F', child: Text('Female')),
                ],
                validator: FormBuilderValidators.required(),
              ),
          ],
        ),
      ),
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
    final formState = _formKey.currentState;

    if (formState == null || !formState.saveAndValidate()) {
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
      final formData = _formKey.currentState?.value;

      if (formData == null) {
        return;
      }

      final request = isEditing
          ? ChildUpdateRequest(
              firstName: formData['firstName'],
              lastName: formData['lastName'],
              birthDate: formData['birthDate'],
            )
          : ChildInsertRequest(
              firstName: formData['firstName'],
              lastName: formData['lastName'],
              birthDate: formData['birthDate'],
              gender: formData['gender'],
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
