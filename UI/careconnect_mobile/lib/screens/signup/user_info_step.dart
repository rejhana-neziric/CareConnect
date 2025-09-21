import 'package:careconnect_mobile/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

class UserInfoStep extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;
  final Function(Map<String, dynamic>) onDataChanged;
  final VoidCallback onNext;
  final Map<String, dynamic>? initialData;

  const UserInfoStep({
    super.key,
    required this.onDataChanged,
    required this.onNext,
    this.initialData,
    required this.formKey,
  });

  @override
  State<UserInfoStep> createState() => _UserInfoStepState();
}

class _UserInfoStepState extends State<UserInfoStep>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  GlobalKey<FormBuilderState> get _formKey => widget.formKey;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialData != null && _formKey.currentState != null) {
        _formKey.currentState!.patchValue(widget.initialData!);
      }
    });
  }

  @override
  void didUpdateWidget(covariant UserInfoStep oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialData != oldWidget.initialData) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_formKey.currentState != null) {
          _formKey.currentState!.patchValue(widget.initialData ?? {});
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Tell us about yourself',
              style: TextStyle(fontSize: 16, color: colorScheme.onSurface),
            ),

            const SizedBox(height: 32),

            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: FormBuilder(
                key: _formKey,
                initialValue: widget.initialData ?? {},
                child: Column(
                  children: [
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
                          errorText: 'Last name is required',
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
                      name: 'email',
                      label: 'Email',
                      icon: Icons.email_outlined,
                      validators: [
                        (value) {
                          if (value != null && value.isNotEmpty) {
                            final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                            if (!emailRegex.hasMatch(value)) {
                              return 'Invalid email.';
                            }
                          }
                          return null;
                        },
                      ],
                    ),

                    const SizedBox(height: 20),

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

                            if (digitsOnly.length < 8 ||
                                digitsOnly.length > 9) {
                              return 'Phone number must be 8 or 9 digits long.';
                            }
                          }
                          return null;
                        },
                      ],
                      prefixText: '+387 ',
                    ),

                    const SizedBox(height: 20),

                    CustomTextField(
                      name: 'username',
                      label: 'Username',
                      icon: Icons.alternate_email,
                      validators: [
                        FormBuilderValidators.required(
                          errorText: 'Username is required',
                        ),
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
                    const SizedBox(height: 20),

                    CustomTextField(
                      name: 'password',
                      label: 'Password',
                      icon: Icons.password_outlined,
                      validators: [
                        FormBuilderValidators.required(
                          errorText: 'Password is required.',
                        ),
                        FormBuilderValidators.minLength(
                          8,
                          errorText:
                              'Password must be at least 8 characters long.',
                        ),
                        FormBuilderValidators.maxLength(
                          32,
                          errorText: 'Password must not exceed 32 characters.',
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

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
                              _formKey
                                  .currentState
                                  ?.fields['password']
                                  ?.value ??
                              '';
                          if (value != password) {
                            return 'Passwords do not match.';
                          }
                          return null;
                        },
                      ],
                    ),

                    const SizedBox(height: 20),

                    FormBuilderDateTimePicker(
                      name: 'birthDate',
                      decoration: InputDecoration(
                        labelText: 'Birth Date',
                        prefixIcon: const Icon(Icons.calendar_today_outlined),
                        prefixIconColor: colorScheme.primary,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      format: DateFormat('dd. MM. yyyy'),
                      inputType: InputType.date,
                    ),

                    const SizedBox(height: 20),

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

                    const SizedBox(height: 20),

                    CustomTextField(
                      name: 'address',
                      label: 'Address',
                      icon: Icons.location_on_outlined,
                      validators: [
                        (value) {
                          if (value != null &&
                              value.isNotEmpty &&
                              value.length < 5) {
                            return 'Address must be at least 5 characters.';
                          }
                          if (value != null &&
                              value.isNotEmpty &&
                              value.length > 100) {
                            return 'Address must not exceed 100 characters.';
                          }
                          return null;
                        },
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _handleNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleNext() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      widget.onDataChanged(_formKey.currentState!.value);
      widget.onNext();
    }
  }
}
