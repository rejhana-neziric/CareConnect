import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ClientInfoStep extends StatefulWidget {
  final Function(Map<String, dynamic>) onDataChanged;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final Map<String, dynamic>? initialData;
  final GlobalKey<FormBuilderState> formKey;

  const ClientInfoStep({
    super.key,
    required this.onDataChanged,
    required this.onNext,
    required this.onBack,
    this.initialData,
    required this.formKey,
  });

  @override
  State<ClientInfoStep> createState() => _ClientInfoStepState();
}

class _ClientInfoStepState extends State<ClientInfoStep>
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
  void didUpdateWidget(covariant ClientInfoStep oldWidget) {
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
              'Client Information',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Additional details about your status',
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
                    FormBuilderSwitch(
                      name: 'employmentStatus',
                      title: const Text(
                        'Currently Employed',
                        style: TextStyle(fontSize: 16),
                      ),
                      subtitle: const Text('Are you currently employed?'),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: colorScheme.primary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'This information helps us provide better care services for your family.',
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
                    onPressed: widget.onBack,
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
                    onPressed: _handleNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 8,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
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

  void _handleNext() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      widget.onDataChanged(_formKey.currentState!.value);
      widget.onNext();
    }
  }
}
