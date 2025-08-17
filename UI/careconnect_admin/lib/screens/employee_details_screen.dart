import 'package:careconnect_admin/layouts/master_screen.dart';
import 'package:careconnect_admin/models/responses/employee.dart';
import 'package:careconnect_admin/models/responses/search_result.dart';
import 'package:careconnect_admin/providers/employee_form_provider.dart';
import 'package:careconnect_admin/providers/employee_provider.dart';
import 'package:careconnect_admin/theme/app_colors.dart';
import 'package:careconnect_admin/utils.dart';
import 'package:careconnect_admin/widgets/confirm_dialog.dart';
import 'package:careconnect_admin/widgets/custom_date_field.dart';
import 'package:careconnect_admin/widgets/custom_dropdown_field.dart';
import 'package:careconnect_admin/widgets/custom_text_field.dart';
import 'package:careconnect_admin/widgets/primary_button.dart';
import 'package:careconnect_admin/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class EmployeeDetailsScreen extends StatefulWidget {
  final Employee? employee;

  const EmployeeDetailsScreen({super.key, this.employee});

  @override
  State<EmployeeDetailsScreen> createState() => _EmployeeDetailsScreenState();
}

class _EmployeeDetailsScreenState extends State<EmployeeDetailsScreen> {
  Map<String, dynamic> _initialValue = {};
  SearchResult<Employee>? result;
  late EmployeeProvider employeeProvider;
  late EmployeeFormProvider employeeFormProvider;
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    employeeProvider = context.read<EmployeeProvider>();
    employeeFormProvider = context.read<EmployeeFormProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initForm();
    });
  }

  Future<void> initForm() async {
    if (widget.employee == null) {
      employeeFormProvider.setForInsert();
    } else {
      employeeFormProvider.setForUpdate({
        "username": widget.employee?.user?.username,
        "firstName": widget.employee?.user?.firstName,
        "lastName": widget.employee?.user?.lastName,
        "status": widget.employee?.user?.status,
        "email": widget.employee?.user?.email,
        "phoneNumber": widget.employee?.user?.phoneNumber,
        "address": widget.employee?.user?.address,
        "hireDate": widget.employee?.hireDate,
        "endDate": widget.employee?.endDate,
        "jobTitle": widget.employee?.jobTitle,
        "qualificationName": widget.employee?.qualification?.name,
        "qualificationInstituteName":
            widget.employee?.qualification?.instituteName,
        "qualificationProcurementYear":
            widget.employee?.qualification?.procurementYear,
        "birthDate": widget.employee?.user?.birthDate,
        "gender": widget.employee?.user?.gender,
      });
    }

    setState(() {
      _initialValue = Map<String, dynamic>.from(
        employeeFormProvider.initialData,
      );
      isLoading = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (employeeFormProvider.formKey.currentState != null) {
        employeeFormProvider.formKey.currentState!.patchValue(_initialValue);
      }
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      "Employee Details",
      SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (!isLoading) _buildForm(),
                const SizedBox(height: 20),
                _actionButtons(),
              ],
            ),
          ),
        ),
      ),
      onBackPressed: () => employeeFormProvider.handleBackPressed(context),
    );
  }

  Widget _buildForm() {
    final employeeFormProvider = Provider.of<EmployeeFormProvider>(context);

    return FormBuilder(
      key: employeeFormProvider.formKey,
      autovalidateMode: AutovalidateMode.disabled,
      initialValue: _initialValue,
      onChanged: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [buildSectionTitle("Personal Information")],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    width: 400,
                    name: 'firstName',
                    label: 'First Name',
                    required: true,
                    validator: employeeFormProvider.validateName,
                    enabled: !employeeFormProvider.isUpdate,
                  ),
                  CustomDateField(
                    width: 400,
                    name: 'birthDate',
                    label: 'Birth Date',
                    enabled: !employeeFormProvider.isUpdate,
                  ),
                  CustomTextField(
                    width: 400,
                    name: 'address',
                    label: 'Address',
                    validator: employeeFormProvider.validateAddress,
                  ),
                  CustomTextField(
                    width: 400,
                    name: 'email',
                    label: 'Email',
                    validator: employeeFormProvider.validateEmail,
                  ),
                  CustomTextField(
                    width: 400,
                    name: 'username',
                    label: 'Username',
                    required: true,
                    validator: employeeFormProvider.validateUsername,
                  ),
                ],
              ),
              const SizedBox(width: 60),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    width: 400,
                    name: 'lastName',
                    label: 'Last Name',
                    required: true,
                    validator: employeeFormProvider.validateName,
                    enabled: !employeeFormProvider.isUpdate,
                  ),
                  CustomDropdownField<String>(
                    width: 400,
                    name: 'gender',
                    label: 'Gender',
                    required: true,
                    items: [
                      DropdownMenuItem(value: 'M', child: Text('Male')),
                      DropdownMenuItem(value: 'F', child: Text('Female')),
                    ],
                    validator: employeeFormProvider.validateNonEmpty,
                    enabled: !employeeFormProvider.isUpdate,
                  ),
                  CustomTextField(
                    width: 400,
                    name: 'phoneNumber',
                    hintText: '61234567',
                    prefixText: '+387 ',
                    label: 'Phone Number',
                    validator: employeeFormProvider.validatePhoneNumber,
                  ),
                  CustomTextField(
                    width: 400,
                    name: 'password',
                    label: 'Password',
                    required: employeeFormProvider.isUpdate == true
                        ? false
                        : true,
                    validator: (value) =>
                        employeeFormProvider.validatePassword(value),
                  ),
                  CustomTextField(
                    width: 400,
                    name: 'confirmationPassword',
                    label: 'Confirmation Password',
                    required: employeeFormProvider.isUpdate == true
                        ? false
                        : true,
                    validator: (value) {
                      final password = employeeFormProvider
                          .formKey
                          .currentState
                          ?.fields['password']
                          ?.value;

                      return employeeFormProvider.validateConfirmationPassword(
                        value,
                        password,
                      );
                    },
                    enabled: !employeeFormProvider.isUpdate,
                  ),
                  if (employeeFormProvider.isUpdate)
                    CustomDropdownField<bool>(
                      width: 400,
                      name: 'status',
                      label: 'Status',
                      items: [
                        DropdownMenuItem(value: true, child: Text('Active')),
                        DropdownMenuItem(value: false, child: Text('Inactive')),
                      ],
                      validator: employeeFormProvider.validateNonEmptyBool,
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 40, height: 80),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildSectionTitle("Job Details"),
                  CustomTextField(
                    width: 400,
                    name: 'jobTitle',
                    label: 'Job Title',
                    required: true,
                    validator: employeeFormProvider.validateNonEmpty,
                  ),
                  CustomDateField(
                    width: 400,
                    name: 'hireDate',
                    label: 'Hire Date',
                    required: true,
                    validator: employeeFormProvider.validateDate,
                    enabled: !employeeFormProvider.isUpdate,
                  ),
                  CustomDateField(
                    width: 400,
                    name: 'endDate',
                    label: 'End Date',
                  ),
                ],
              ),
              const SizedBox(width: 60),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildSectionTitle("Qualification"),
                  CustomTextField(
                    width: 400,
                    name: 'qualificationName',
                    label: 'Qualification Name',
                    required: true,
                    validator: employeeFormProvider.validateNonEmpty,
                  ),
                  CustomTextField(
                    width: 400,
                    name: 'qualificationInstituteName',
                    label: 'Qualification Institute Name',
                    required: true,
                    validator: employeeFormProvider.validateNonEmpty,
                  ),
                  CustomDateField(
                    width: 400,
                    name: 'qualificationProcurementYear',
                    label: 'Qualification Procurement Year',
                    required: true,
                    validator: employeeFormProvider.validateDate,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButtons() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return SizedBox(
      child: Row(
        children: [
          if (widget.employee != null)
            PrimaryButton(
              onPressed: () async {
                delete();
              },
              label: 'Delete',
              backgroundColor: colorScheme.error,
            ),

          Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PrimaryButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                label: 'Cancel',
              ),
              SizedBox(width: 10),
              PrimaryButton(
                onPressed: () async {
                  save();
                },
                label: 'Save',
              ),
            ],
          ),
        ],
      ),
    );
  }

  void delete() async {
    final id = widget.employee?.user?.userId;

    final shouldProceed = await CustomConfirmDialog.show(
      context,
      icon: Icons.info,

      title: 'Delete Employee',
      content: 'Are you sure you want to delete this employee?',
      confirmText: 'Delete',
      cancelText: 'Cancel',
    );

    if (shouldProceed != true) return;

    final success = await employeeProvider.delete(id!);

    if (!mounted) return;

    CustomSnackbar.show(
      context,
      message: success
          ? 'Employee successfully deleted.'
          : 'Something went wrong. Please try again.',
      type: success ? SnackbarType.success : SnackbarType.error,
    );

    if (success) {
      Navigator.of(context).pop(success);
    }
  }

  void save() async {
    final formState = employeeFormProvider.formKey.currentState;

    if (formState == null || !formState.saveAndValidate()) {
      debugPrint('Form is not valid or state is null');
      return;
    }

    final id = widget.employee?.user?.userId;
    final isInsert = widget.employee == null;

    final shouldProceed = await CustomConfirmDialog.show(
      context,
      icon: Icons.info,
      iconBackgroundColor: AppColors.mauveGray,
      title: isInsert ? 'Add New Employee' : 'Save Changes',
      content: isInsert
          ? 'Are you sure you want to add a new employee?'
          : 'Are you sure you want to save the changes?',
      confirmText: 'Continue',
      cancelText: 'Cancel',
    );

    if (shouldProceed != true) return;

    final success = await employeeFormProvider.saveOrUpdate(
      employeeFormProvider,
      employeeProvider,
      id,
    );

    if (!mounted) return;

    CustomSnackbar.show(
      context,
      message: success
          ? (employeeFormProvider.isUpdate
                ? 'Employee updated.'
                : 'Employee added.')
          : 'Something went wrong. Please try again.',
      type: success ? SnackbarType.success : SnackbarType.error,
    );

    if (success && !employeeFormProvider.isUpdate) {
      setState(() {});
      employeeFormProvider.resetForm();
    }

    if (success) {
      employeeFormProvider.saveInitialValue();
    }

    employeeFormProvider.success = success;
  }
}
