import 'package:careconnect_mobile/core/theme/app_colors.dart';
import 'package:careconnect_mobile/models/requests/client_update_request.dart';
import 'package:careconnect_mobile/models/requests/user_update_request.dart';
import 'package:careconnect_mobile/models/responses/client.dart';
import 'package:careconnect_mobile/screens/profile/widgets/profile_header.dart';
import 'package:careconnect_mobile/widgets/confim_dialog.dart';
import 'package:careconnect_mobile/widgets/primary_button.dart';
import 'package:careconnect_mobile/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

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
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Form controllers
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _usernameController;
  late TextEditingController _addressController;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmationPasswordController =
      TextEditingController();

  // Form state
  DateTime? _selectedBirthDate;
  String _selectedGender = 'M';
  bool _accountStatus = true;
  bool _employmentStatus = true;
  bool _isLoading = false;

  // Available options
  final List<String> _genderOptions = ['M', 'F'];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _setupAnimation();

    _passwordController.addListener(() {
      setState(() {});
    });
  }

  void _initializeControllers() {
    final user = widget.client.user;

    _firstNameController = TextEditingController(text: user?.firstName ?? '');
    _lastNameController = TextEditingController(text: user?.lastName ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phoneNumber ?? '');
    _usernameController = TextEditingController(text: user?.username ?? '');
    _addressController = TextEditingController(text: user?.address ?? '');

    _selectedBirthDate = user?.birthDate;
    _selectedGender = user?.gender ?? 'Male';
    _accountStatus = user?.status ?? true;
    _employmentStatus = widget.client.employmentStatus;
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
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _usernameController.dispose();
    _addressController.dispose();
    _animationController.dispose();
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildProfileHeader(widget.client.user, colorScheme),
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
        _buildTextFormField(
          controller: _firstNameController,
          label: 'First Name',
          icon: Icons.person_outline,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'This fiels is required.';
            }
            if (value.length < 2) return 'Name must be at least 2 characters.';
            if (value.length > 50) return 'Name must not exceed 50 characters.';
            return null;
          },
          colorScheme: colorScheme,
        ),
        const SizedBox(height: 16),
        _buildTextFormField(
          controller: _lastNameController,
          label: 'Last Name',
          icon: Icons.person_outline,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'This fiels is required.';
            }
            if (value.length < 2) return 'Name must be at least 2 characters.';
            if (value.length > 50) return 'Name must not exceed 50 characters.';
            return null;
          },
          colorScheme: colorScheme,
        ),
        const SizedBox(height: 16),
        _buildTextFormField(
          controller: _usernameController,
          label: 'Username',
          icon: Icons.alternate_email,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Username is required.';
            }
            if (value.length < 4) {
              return 'Username must be at least 4 characters.';
            }
            if (value.length > 20) {
              return 'Username must not exceed 20 characters.';
            }
            return null;
          },
          colorScheme: colorScheme,
        ),
        const SizedBox(height: 16),
        _buildTextFormField(
          controller: _passwordController,
          label: 'New Password',
          icon: Icons.password_outlined,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return null;
            }
            if (value.length < 8) {
              return 'Password must be at least 8 characters.';
            }
            if (value.length > 32) {
              return 'Password must not exceed 32 characters.';
            }
            return null;
          },
          colorScheme: colorScheme,
        ),
        if (_passwordController.text.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildTextFormField(
            controller: _confirmationPasswordController,
            label: 'Confirmation Passwornd',
            icon: Icons.password_outlined,
            validator: (value) {
              if (_passwordController.text.isEmpty) {
                return 'Confirmation password is required.';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match.';
              }
              return null;
            },
            colorScheme: colorScheme,
          ),
        ],
        const SizedBox(height: 16),
        _buildTextFormField(
          controller: _addressController,
          label: 'Address',
          icon: Icons.location_on_outlined,
          maxLines: 2,
          colorScheme: colorScheme,
          validator: (value) {
            if (value != null && value.trim().isNotEmpty) {
              if (value.length < 5) {
                return 'Address must be at least 5 characters.';
              }
              if (value.length > 100) {
                return 'Address must not exceed 100 characters.';
              }
            }

            return null;
          },
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
        _buildTextFormField(
          controller: _phoneController,
          label: 'Phone Number',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          colorScheme: colorScheme,
          validator: (value) {
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
          },
          prefixText: '+387 ',
        ),
        const SizedBox(height: 16),

        _buildTextFormField(
          controller: _emailController,
          label: 'Email',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
              if (!emailRegex.hasMatch(value)) return 'Invalid email.';
            }

            return null;
          },
          colorScheme: colorScheme,
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

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
    required ColorScheme colorScheme,
    String? prefixText,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,

      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: colorScheme.primary),
        prefixText: prefixText,
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
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
      items: _genderOptions.map((gender) {
        return DropdownMenuItem<String>(value: gender, child: Text(gender));
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedGender = value!;
        });
      },
    );
  }

  Widget _buildDatePicker(ColorScheme colorScheme) {
    return InkWell(
      onTap: () => _selectBirthDate(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.primary),
          borderRadius: BorderRadius.circular(12),
          color: colorScheme.surfaceContainerLow,
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _selectedBirthDate != null
                    ? 'Birth Date: ${DateFormat('d. MM. yyyy.').format(_selectedBirthDate!)}'
                    : 'Select Birth Date',
                style: TextStyle(
                  fontSize: 16,
                  color: _selectedBirthDate != null
                      ? colorScheme.onSurface
                      : Colors.grey.shade600,
                ),
              ),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
          ],
        ),
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
        color: colorScheme.surfaceContainerLow, //Colors.grey.shade50,
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

  Future<void> _selectBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedBirthDate ??
          DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = picked;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
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
      final updatedClient = ClientUpdateRequest(
        employmentStatus: _employmentStatus,
        user: UserUpdateRequest(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text.isEmpty ? null : _emailController.text,
          phoneNumber: _phoneController.text.isEmpty
              ? null
              : _phoneController.text,
          username: _usernameController.text,
          address: _addressController.text.isEmpty
              ? null
              : _addressController.text,
          status: _accountStatus,
          password: _passwordController.text.isEmpty
              ? null
              : _passwordController.text,
          confirmationPassword: _confirmationPasswordController.text.isEmpty
              ? null
              : _confirmationPasswordController.text,
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
