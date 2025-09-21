import 'package:careconnect_mobile/widgets/custom_text_field.dart';
import 'package:careconnect_mobile/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

class ChildInfoStep extends StatefulWidget {
  final Function(Map<String, dynamic>) onDataChanged;
  final VoidCallback onBack;
  final VoidCallback onComplete;
  final Map<String, dynamic>? initialData;
  final GlobalKey<FormBuilderState> formKey;

  const ChildInfoStep({
    super.key,
    required this.onDataChanged,
    required this.onBack,
    required this.onComplete,
    this.initialData,
    required this.formKey,
  });

  @override
  State<ChildInfoStep> createState() => _ChildInfoStepState();
}

class _ChildInfoStepState extends State<ChildInfoStep>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  GlobalKey<FormBuilderState> get _formKey => widget.formKey;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isLoading = false;

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
  void didUpdateWidget(covariant ChildInfoStep oldWidget) {
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
              'Child Information',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Tell us about your child',
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
                      name: 'childfirstName',
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
                      name: 'childlastName',
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
                      name: 'childbirthDate',
                      validator: FormBuilderValidators.required(),
                      decoration: InputDecoration(
                        labelText: 'Birth Date',
                        prefixIcon: const Icon(Icons.calendar_today_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: colorScheme.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      inputType: InputType.date,
                      firstDate: DateTime.now().subtract(
                        const Duration(days: 365 * 18),
                      ),
                      lastDate: DateTime.now(),
                      format: DateFormat('dd. MM. yyyy'),
                    ),

                    const SizedBox(height: 20),

                    FormBuilderDropdown<String>(
                      name: 'childgender',
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

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.security, color: Colors.green[700]),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'All information is securely encrypted and protected according to privacy standards.',
                              style: TextStyle(
                                color: colorScheme.onSurface,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : widget.onBack,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Back',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleComplete,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 8,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.check_circle_outline),
                              const SizedBox(width: 8),
                              const Text(
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleComplete() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      widget.onDataChanged(_formKey.currentState!.value);

      try {
        widget.onComplete();
      } catch (e) {
        CustomSnackbar.show(
          context,
          message: 'Something went wrong. Please try againg.',
          type: SnackbarType.error,
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }
}
