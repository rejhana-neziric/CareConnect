import 'package:careconnect_admin/core/layouts/master_screen.dart';
import 'package:careconnect_admin/core/theme/app_colors.dart';
import 'package:careconnect_admin/models/auth_user.dart';
import 'package:careconnect_admin/models/requests/employee_update_request.dart';
import 'package:careconnect_admin/models/requests/qualification_update_request.dart';
import 'package:careconnect_admin/models/requests/user_update_request.dart';
import 'package:careconnect_admin/models/responses/employee.dart';
import 'package:careconnect_admin/models/responses/user.dart';
import 'package:careconnect_admin/models/search_objects/employee_additional_data.dart';
import 'package:careconnect_admin/providers/auth_provider.dart';
import 'package:careconnect_admin/providers/employee_form_provider.dart';
import 'package:careconnect_admin/providers/employee_provider.dart';
import 'package:careconnect_admin/providers/user_form_provider.dart';
import 'package:careconnect_admin/providers/user_provider.dart';
import 'package:careconnect_admin/widgets/confirm_dialog.dart';
import 'package:careconnect_admin/widgets/custom_date_field.dart';
import 'package:careconnect_admin/widgets/custom_dropdown_field.dart';
import 'package:careconnect_admin/widgets/custom_text_field.dart';
import 'package:careconnect_admin/widgets/primary_button.dart';
import 'package:careconnect_admin/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isEditing = false;
  bool _isLoading = false;

  AuthUser? currentUser;

  Map<String, dynamic> _initialValue = {};
  bool isLoading = false;

  late EmployeeProvider employeeProvider;
  late UserProvider userProvider;
  late EmployeeFormProvider employeeFormProvider;
  late UserFormProvider userFormProvider;

  late bool isEmployee;
  User? user;
  Employee? employee;

  @override
  void initState() {
    super.initState();

    final auth = Provider.of<AuthProvider>(context, listen: false);

    currentUser = auth.user;

    isEmployee = currentUser?.roles.contains('Superadmin') ?? false;

    employeeProvider = context.read<EmployeeProvider>();
    userProvider = context.read<UserProvider>();
    employeeFormProvider = context.read<EmployeeFormProvider>();
    userFormProvider = context.read<UserFormProvider>();

    getUser();
  }

  Future<void> getUser() async {
    if (currentUser == null) return;

    setState(() {
      isLoading = true;
    });

    var additionalData = EmployeeAdditionalData(isQualificationIncluded: true);

    final filter = additionalData.toJson();

    employee = await employeeProvider.getById(currentUser!.id, filter: filter);
    user = await userProvider.getById(currentUser!.id);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initForm();
    });

    setState(() {
      isLoading = false;
    });
  }

  Future<void> initForm() async {
    setState(() {
      isLoading = true;
    });

    _initialValue = {
      "username": user?.username,
      "firstName": user?.firstName,
      "lastName": user?.lastName,
      "status": user?.status,
      "email": user?.email,
      "phoneNumber": user?.phoneNumber,
      "address": user?.address,
      "birthDate": user?.birthDate,
      "gender": user?.gender,
      "hireDate": employee?.hireDate,
      "endDate": employee?.endDate,
      "jobTitle": employee?.jobTitle,
      "qualificationName": employee?.qualification?.name,
      "qualificationInstituteName": employee?.qualification?.instituteName,
      "qualificationProcurementYear": employee?.qualification?.procurementYear,
    };

    setState(() {
      isLoading = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_formKey.currentState != null) {
        _formKey.currentState!.patchValue(_initialValue);
      }
    });

    setState(() {});
  }

  Future<void> _saveProfile() async {
    if (currentUser == null) return;

    final formState = _formKey.currentState;

    if (formState == null || !formState.saveAndValidate()) {
      debugPrint('Form is not valid or state is null');
      return;
    }

    final shouldProceed = await CustomConfirmDialog.show(
      context,
      iconBackgroundColor: AppColors.accentDeepMauve,
      icon: Icons.info,
      title: 'Edit',
      content: 'Are you sure you want to save changes?',
      confirmText: 'Save',
      cancelText: 'Cancel',
    );

    if (shouldProceed != true) return;

    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final formData = _formKey.currentState?.value;

      if (formData == null) {
        return;
      }

      final updateUser = UserUpdateRequest(
        firstName: formData['firstName'],
        lastName: formData['lastName'],
        email: formData['email']?.isEmpty == true ? null : formData['email'],
        phoneNumber: formData['phoneNumber']?.isEmpty == true
            ? null
            : formData['phoneNumber'],
        username: formData['username'],
        address: formData['address']?.isEmpty == true
            ? null
            : formData['address'],
      );

      EmployeeUpdateRequest? updateEmployee;

      if (isEmployee) {
        updateEmployee = EmployeeUpdateRequest(
          jobTitle: formData['jobTitle'],
          qualification: QualificationUpdateRequest(
            name: formData['qualitificationName'],
            instituteName: formData['qualificationInstituteName'],
            procurementYear: formData['qualificationProcurementYear'],
          ),
          user: updateUser,
        );
      }

      isEmployee && updateEmployee != null
          ? employeeProvider.update(currentUser!.id, updateEmployee)
          : userProvider.update(currentUser!.id, updateUser);

      if (mounted) {
        CustomSnackbar.show(
          context,
          message: 'Profile updated successfully!',
          type: SnackbarType.success,
        );

        _isEditing = false;
        // Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar.show(
          context,
          message: 'Something went wrong. Please try again.',
          type: SnackbarType.success,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MasterScreen(
      "My Profile",

      isLoading
          ? const Center(child: CircularProgressIndicator())
          : Scaffold(
              backgroundColor: colorScheme.surfaceContainerLowest,
              body: Row(
                children: [
                  Container(
                    width: 320,
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [colorScheme.primary, colorScheme.secondary],
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        _buildProfileAvatar(),
                        const SizedBox(height: 24),
                        Text(
                          '${user?.firstName} ${user?.lastName}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currentUser?.roles.join(', ') ?? 'Not set',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildQuickInfo(),
                        const Spacer(),
                        PrimaryButton(
                          onPressed: () => _showChangePasswordDialog(
                            context,
                            currentUser?.id,
                          ),
                          icon: Icons.lock_outline,
                          label: 'Change Password',
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),

                  // Right Content Area
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(40),
                      child: FormBuilder(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.disabled,
                        initialValue: _initialValue,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(),
                            const SizedBox(height: 32),
                            _buildPersonalInfoSection(),
                            if (isEmployee) ...[
                              const SizedBox(height: 32),
                              _buildEmployeeInfoSection(),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      currentScreen: "Profile",
    );
  }

  Widget _buildProfileAvatar() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Stack(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.white,
          child: Text(
            '${user?.firstName[0]}${user?.lastName[0]}',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _buildQuickInfoItem(
            Icons.email_outlined,
            user?.email ?? 'Not provided.',
          ),
          const SizedBox(height: 16),
          _buildQuickInfoItem(
            Icons.phone_outlined,
            user?.phoneNumber ?? 'Not provided.',
          ),
          const SizedBox(height: 16),
          _buildQuickInfoItem(
            Icons.calendar_today_outlined,
            user?.birthDate != null
                ? DateFormat('dd. MM. yyyy.').format(user!.birthDate!)
                : 'Not provided.',
          ),
        ],
      ),
    );
  }

  Widget _buildQuickInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.white),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14, color: AppColors.white),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _showChangePasswordDialog(BuildContext context, int? userId) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    if (userId == null) return;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 400,
                  child: TextFormField(
                    controller: currentPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'Current Password',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your current password.';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 400,
                  child: TextFormField(
                    controller: newPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'New Password',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a new password.';
                      } else if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      } else if (value.length > 32) {
                        return 'Password must not exceed 32 characters.';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 400,
                  child: TextFormField(
                    controller: confirmPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                    ),
                    validator: (value) {
                      if (value != newPasswordController.text) {
                        return 'Passwords do not match.';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),

            PrimaryButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  Navigator.of(ctx).pop();

                  final success = await userProvider.changePassword(
                    userId: userId,
                    oldPassword: currentPasswordController.text,
                    newPassword: newPasswordController.text,
                  );

                  if (success) {
                    CustomSnackbar.show(
                      context,
                      message: 'Password changes successfully',
                      type: SnackbarType.success,
                    );
                  } else {
                    CustomSnackbar.show(
                      context,
                      message: 'Something went wrong. Please try again.',
                      type: SnackbarType.error,
                    );
                  }
                }
              },
              label: 'Save',
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Profile Details',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            if (_isEditing) ...[
              Tooltip(
                message: 'Revert to last saved values.',
                child: TextButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          setState(() {
                            _isEditing = false;
                            initForm();
                          });
                        },
                  child: const Text('Cancel'),
                ),
              ),

              const SizedBox(width: 12),

              PrimaryButton(
                onPressed: _isLoading ? () => null : _saveProfile,
                label: _isLoading ? 'Saving...' : 'Save Changes',
              ),
            ] else
              PrimaryButton(
                onPressed: () => setState(() => _isEditing = true),
                label: 'Edit Profile',
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildPersonalInfoSection() {
    return _buildSection(
      title: 'Personal Information',
      icon: Icons.person_outline,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  width: double.infinity,
                  name: 'firstName',
                  label: 'First Name',
                  required: true,
                  validator: userFormProvider.validateName,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  width: double.infinity,
                  name: 'lastName',
                  label: 'Last Name',
                  required: true,
                  validator: userFormProvider.validateName,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  width: double.infinity,
                  name: 'username',
                  label: 'Username',
                  enabled: false,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomDropdownField<String>(
                  width: 400,
                  name: 'gender',
                  label: 'Gender',
                  required: true,
                  items: [
                    DropdownMenuItem(value: 'M', child: Text('Male')),
                    DropdownMenuItem(value: 'F', child: Text('Female')),
                  ],
                  enabled: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  width: double.infinity,
                  name: 'email',
                  label: 'Email',
                  validator: userFormProvider.validateEmail,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  width: double.infinity,
                  name: 'phoneNumber',
                  label: 'Phone Number',
                  validator: userFormProvider.validatePhoneNumber,
                  hintText: '61234567',
                  prefixText: '+387 ',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: CustomDateField(
                  width: 400,
                  name: 'birthDate',
                  label: 'Birth Date',
                  enabled: false,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  width: double.infinity,
                  name: 'address',
                  label: 'Address',
                  validator: userFormProvider.validateAddress,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeInfoSection() {
    return _buildSection(
      title: 'Employment Information',
      icon: Icons.work_outline,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  width: double.infinity,
                  name: 'jobTitle',
                  label: 'Job Title',
                  enabled: false,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomDateField(
                  width: double.infinity,
                  name: 'hireDate',
                  label: 'Hire Date',
                  enabled: false,
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),

          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  width: double.infinity,
                  name: 'qualificationName',
                  label: 'Qualification Name',
                  enabled: false,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomDateField(
                  width: double.infinity,
                  name: 'qualificationProcurementYear',
                  label: 'Procurement Year',
                  enabled: false,
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  width: double.infinity,
                  name: 'qualificationInstituteName',
                  label: 'Qualification Institute Name',
                  validator: employeeFormProvider.validateNonEmpty,
                  enabled: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }
}
