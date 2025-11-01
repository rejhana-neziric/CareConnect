import 'package:careconnect_admin/core/layouts/master_screen.dart';
import 'package:careconnect_admin/models/responses/employee.dart';
import 'package:careconnect_admin/models/responses/role.dart';
import 'package:careconnect_admin/models/responses/search_result.dart';
import 'package:careconnect_admin/providers/employee_form_provider.dart';
import 'package:careconnect_admin/providers/employee_provider.dart';
import 'package:careconnect_admin/core/theme/app_colors.dart';
import 'package:careconnect_admin/core/utils.dart';
import 'package:careconnect_admin/providers/permission_provider.dart';
import 'package:careconnect_admin/providers/role_permissions_provider.dart';
import 'package:careconnect_admin/providers/user_provider.dart';
import 'package:careconnect_admin/screens/no_permission_screen.dart';
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
  List<Role> userRoles = [];
  List<Role> roles = [];
  late EmployeeProvider employeeProvider;
  late EmployeeFormProvider employeeFormProvider;
  late UserProvider userProvider;
  late RolePermissionsProvider rolePermissionsProvider;

  bool isLoading = true;

  bool isAccessAllowed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    employeeProvider = context.read<EmployeeProvider>();
    employeeFormProvider = context.read<EmployeeFormProvider>();
    userProvider = context.read<UserProvider>();
    rolePermissionsProvider = context.read<RolePermissionsProvider>();

    if (widget.employee != null) {
      getRoles();
    }

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

      isAccessAllowed = widget.employee!.user!.status;
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

  void getRoles() async {
    setState(() {
      isLoading = true;
    });

    final response = await userProvider.getRoles(
      userId: widget.employee!.user!.userId,
    );

    final allRoles = await rolePermissionsProvider.getRoles();

    userRoles = response;
    roles = allRoles;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final permissionProvider = context.watch<PermissionProvider>();

    if (!permissionProvider.canGetByIdEmployee()) {
      return MasterScreen(
        'Employee Details',
        NoPermissionScreen(),
        currentScreen: "Employees",
      );
    }

    return MasterScreen(
      "Employee Details",
      currentScreen: "Employees",
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

                if ((permissionProvider.canEditEmployee() &&
                        widget.employee != null) ||
                    (permissionProvider.canInsertEmployee() &&
                        widget.employee == null) ||
                    (permissionProvider.canDeleteEmployee() &&
                        widget.employee != null))
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

    final permissionProvider = context.watch<PermissionProvider>();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
            children: [buildSectionTitle("Personal Information", colorScheme)],
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
                  buildSectionTitle("Job Details", colorScheme),
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
                  buildSectionTitle("Qualification", colorScheme),
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
          const SizedBox(width: 40, height: 40),

          if (employeeFormProvider.isUpdate)
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: isAccessAllowed,
                          onChanged: (value) {
                            setState(() {
                              isAccessAllowed = value!;
                            });
                          },
                        ),
                        const Text(
                          'Allow access to application',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'If unchecked, the user will not be able to log in. This action is reversible and can be undone at any time.',
                      style: TextStyle(
                        fontSize: 16,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ],
            ),

          if (widget.employee != null &&
              permissionProvider.canViewRolesForUser() &&
              isLoading == false) ...[
            const SizedBox(width: 40, height: 40),

            buildSectionTitle("Roles", colorScheme),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...userRoles.map((role) {
                  return InputChip(
                    label: Text(role.name),
                    onDeleted: () async {
                      if (permissionProvider.canRemoveRoleFromUser()) {
                        final shouldProceed = await CustomConfirmDialog.show(
                          context,
                          icon: Icons.error,
                          title: 'Remove role',
                          content:
                              'Are you sure you want to remove from this user?',
                          confirmText: 'Remove',
                          cancelText: 'Cancel',
                        );

                        if (shouldProceed != true) return;

                        if (shouldProceed == true) {
                          final success = await userProvider.removeRole(
                            widget.employee!.user!.userId,
                            role.roleId,
                          );
                          if (success) {
                            setState(() {
                              getRoles();
                            });
                            CustomSnackbar.show(
                              context,
                              message: 'Role removed successfully.',
                              type: SnackbarType.success,
                            );
                          } else {
                            CustomSnackbar.show(
                              context,
                              message:
                                  'Failed to remove role. Please try again.',
                              type: SnackbarType.error,
                            );
                          }
                        }
                      }
                    },
                    deleteIcon:
                        permissionProvider.canRemoveRoleFromUser() == true
                        ? const Icon(Icons.close, size: 18)
                        : null,
                    backgroundColor: colorScheme.surfaceContainerLowest,
                  );
                }),

                if (permissionProvider.canAddRoleToUser())
                  PrimaryButton(
                    onPressed: () async {
                      await _showAddRoleDialog(context);
                    },
                    label: 'Add Role',
                    icon: Icons.add,
                  ),
              ],
            ),

            const SizedBox(width: 40, height: 80),
          ],
        ],
      ),
    );
  }

  Future<void> _showAddRoleDialog(BuildContext context) async {
    final selectedRoleId = await showDialog<int>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Assign Role'),
          content: SizedBox(
            width: 400,
            child: DropdownButtonFormField<int>(
              decoration: const InputDecoration(labelText: 'Select Role'),
              items: roles.map((r) {
                return DropdownMenuItem<int>(
                  value: r.roleId,
                  child: Text(r.name),
                );
              }).toList(),
              onChanged: (value) {
                Navigator.pop(ctx, value);
              },
            ),
          ),
        );
      },
    );

    if (selectedRoleId != null && widget.employee != null) {
      final success = await userProvider.addRole(
        widget.employee!.user!.userId,
        selectedRoleId,
      );
      if (success) {
        CustomSnackbar.show(
          context,
          message: 'Role successfully added.',
          type: SnackbarType.success,
        );
        getRoles();
      } else {
        CustomSnackbar.show(
          context,
          message: 'Failed to add role. Please try again.',
          type: SnackbarType.error,
        );
      }
    }
  }

  Widget _actionButtons() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final permissionProvider = context.read<PermissionProvider>();

    return SizedBox(
      child: Row(
        children: [
          if (widget.employee != null && permissionProvider.canDeleteEmployee())
            PrimaryButton(
              onPressed: () async {
                delete();
              },
              label: 'Delete',
              backgroundColor: colorScheme.error,
            ),

          Spacer(),

          if ((permissionProvider.canEditEmployee() &&
                  widget.employee != null) ||
              (permissionProvider.canInsertEmployee() &&
                  widget.employee == null))
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

    final success = await employeeFormProvider.saveOrUpdateCustom(
      employeeFormProvider,
      employeeProvider,
      id,
      isAccessAllowed,
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
