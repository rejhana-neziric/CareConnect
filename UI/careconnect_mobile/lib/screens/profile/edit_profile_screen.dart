import 'package:careconnect_mobile/core/theme/app_colors.dart';
import 'package:careconnect_mobile/models/requests/client_update_request.dart';
import 'package:careconnect_mobile/models/requests/user_update_request.dart';
import 'package:careconnect_mobile/models/responses/client.dart';
import 'package:careconnect_mobile/screens/profile/widgets/profile_header.dart';
import 'package:careconnect_mobile/widgets/confim_dialog.dart';
import 'package:careconnect_mobile/widgets/custom_text_field.dart';
import 'package:careconnect_mobile/widgets/primary_button.dart';
import 'package:careconnect_mobile/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class EditProfileScreen extends StatefulWidget {
  final Client client;
  final Function(ClientUpdateRequest) onUserUpdated;

  const EditProfileScreen({
    super.key,
    required this.client,
    required this.onUserUpdated,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormBuilderState>();

  final _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  bool _accountStatus = true;
  bool _employmentStatus = true;
  bool _isLoading = false;

  Map<String, dynamic> _initialValue = {};

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _setupAnimation();
  }

  void _initializeControllers() {
    final user = widget.client.user;

    _initialValue = {
      'firstName': user?.firstName,
      'lastName': user?.lastName,
      'email': user?.email,
      'phoneNumber': user?.phoneNumber,
      'username': user?.username,
      'address': user?.address,
      'status': user?.status,
      'employmentStatus': widget.client.employmentStatus,
    };
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLow,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: FormBuilder(
            key: _formKey,
            initialValue: _initialValue,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildProfileHeader(context, widget.client.user, colorScheme),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPersonalInfoSection(colorScheme),
                      const SizedBox(height: 24),
                      _buildContactInfoSection(colorScheme),
                      const SizedBox(height: 24),
                      _buildStatusSection(colorScheme),
                      const SizedBox(height: 24),
                      _buildActionButtons(colorScheme),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection(ColorScheme colorScheme) {
    return _buildSection(
      'Personal Information',
      Icons.person,
      colorScheme.surfaceContainerLowest,
      [
        CustomTextField(
          name: 'firstName',
          label: 'First Name',
          icon: Icons.person_outline,
          validators: [
            FormBuilderValidators.required(errorText: 'First name is required'),
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
        const SizedBox(height: 16),

        CustomTextField(
          name: 'lastName',
          label: 'Last Name',
          icon: Icons.person_outline,
          validators: [
            FormBuilderValidators.required(errorText: 'Last name is required'),
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
        const SizedBox(height: 16),

        CustomTextField(
          name: 'username',
          label: 'Username',
          icon: Icons.alternate_email,
          validators: [
            FormBuilderValidators.required(errorText: 'Username is required'),
            FormBuilderValidators.minLength(
              4,
              errorText: 'Username must be at least 4 characters.',
            ),
            FormBuilderValidators.maxLength(
              20,
              errorText: 'Username must not exceed 20 characters.',
            ),
          ],
        ),
        const SizedBox(height: 16),

        CustomTextField(
          name: 'password',
          label: 'New Password',
          icon: Icons.password_outlined,
          validators: [
            (value) {
              if (value != null && value.isNotEmpty && value.length < 8) {
                return 'Password must be at least 8 characters long.';
              }
              if (value != null && value.isNotEmpty && value.length > 32) {
                return 'Password must not exceed 32 characters.';
              }
              return null; // valid if empty or long enough
            },
          ],
        ),

        if (_formKey.currentState?.fields['password']?.value?.isNotEmpty ??
            false) ...[
          const SizedBox(height: 16),
          CustomTextField(
            name: 'confirmPassword',
            label: 'Confirmation Password',
            icon: Icons.password_outlined,
            validators: [
              FormBuilderValidators.required(
                errorText: 'Confirmation password is required.',
              ),
              (value) {
                final password =
                    _formKey.currentState?.fields['password']?.value ?? '';
                if (value != password) {
                  return 'Passwords do not match.';
                }
                return null;
              },
            ],
          ),
        ],

        const SizedBox(height: 16),

        CustomTextField(
          name: 'address',
          label: 'Address',
          icon: Icons.location_on_outlined,
          validators: [
            (value) {
              if (value != null && value.isNotEmpty && value.length < 5) {
                return 'Address must be at least 5 characters.';
              }
              if (value != null && value.isNotEmpty && value.length > 100) {
                return 'Address must not exceed 100 characters.';
              }
              return null;
            },
          ],
        ),
      ],
      colorScheme,
    );
  }

  Widget _buildContactInfoSection(ColorScheme colorScheme) {
    return _buildSection(
      'Contact Information',
      Icons.contact_phone,
      colorScheme.surfaceContainerLowest,
      [
        CustomTextField(
          name: 'phoneNumber',
          label: 'Phone Number',
          icon: Icons.phone_outlined,
          validators: [
            (value) {
              if (value != null && value.isNotEmpty) {
                final digitsOnly = value.trim();

                if (!RegExp(r'^\d+$').hasMatch(digitsOnly)) {
                  return 'Phone number must contain digits only.';
                }

                if (digitsOnly.length < 8 || digitsOnly.length > 9) {
                  return 'Phone number must be 8 or 9 digits long.';
                }
              }
              return null;
            },
          ],
          prefixText: '+387 ',
        ),
        const SizedBox(height: 16),

        CustomTextField(
          name: 'email',
          label: 'Email',
          icon: Icons.email_outlined,
          validators: [
            (value) {
              if (value != null && value.isNotEmpty) {
                final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                if (!emailRegex.hasMatch(value)) return 'Invalid email.';
              }
              return null;
            },
          ],
        ),
      ],
      colorScheme,
    );
  }

  Widget _buildStatusSection(ColorScheme colorScheme) {
    return _buildSection(
      'Status Settings',
      Icons.settings,
      colorScheme.surfaceContainerLowest,
      [
        const SizedBox(height: 8),
        _buildSwitchTile(
          'Employment Status',
          'Currently employed',
          _employmentStatus,
          (value) => setState(() => _employmentStatus = value),
          colorScheme,
        ),
      ],
      colorScheme,
    );
  }

  Widget _buildSection(
    String title,
    IconData icon,
    Color color,
    List<Widget> children,
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: colorScheme.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ColorScheme colorScheme) {
    return Column(
      children: [
        PrimaryButton(
          label: 'Save Changes',
          isLoading: false,
          type: ButtonType.filled,
          onPressed: _isLoading ? null : _saveProfile,
        ),
        const SizedBox(height: 12),
        PrimaryButton(
          label: 'Cancel',
          type: ButtonType.outlined,
          backgroundColor: colorScheme.onSurface,
          onPressed: _isLoading ? null : () => Navigator.pop(context),
        ),
      ],
    );
  }

  Future<void> _saveProfile() async {
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

      final updatedClient = ClientUpdateRequest(
        employmentStatus: _employmentStatus,
        user: UserUpdateRequest(
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
          status: _accountStatus,
          password: formData['password']?.isEmpty == true
              ? null
              : formData['password'],
          confirmationPassword: formData['confirmPassword']?.isEmpty == true
              ? null
              : formData['confirmPassword'],
        ),
      );

      widget.onUserUpdated(updatedClient);

      if (mounted) {
        CustomSnackbar.show(
          context,
          message: 'Profile updated successfully!',
          type: SnackbarType.success,
        );

        Navigator.pop(context);
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
}
