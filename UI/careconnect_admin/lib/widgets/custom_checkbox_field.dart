import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomCheckboxField extends StatefulWidget {
  final double width;
  final String name;
  final String label;
  final bool initialValue;
  final bool required;
  final String? Function(bool?)? validator;
  final bool enabled;

  const CustomCheckboxField({
    super.key,
    required this.width,
    required this.name,
    required this.label,
    this.initialValue = false,
    this.required = false,
    this.validator,
    this.enabled = true,
  });

  @override
  State<CustomCheckboxField> createState() => _CustomCheckboxFieldState();
}

class _CustomCheckboxFieldState extends State<CustomCheckboxField> {
  bool _hasUserInteracted = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: SizedBox(
        width: widget.width,
        child: FormBuilderField<bool>(
          name: widget.name,
          initialValue: widget.initialValue,
          validator: widget.validator,
          autovalidateMode: _hasUserInteracted
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          builder: (field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: widget.enabled
                      ? () {
                          setState(() {
                            _hasUserInteracted = true;
                            field.didChange(!(field.value ?? false));
                          });
                        }
                      : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: colorScheme.primaryContainer,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: colorScheme.surfaceContainerLowest,
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: field.value ?? false,
                          onChanged: widget.enabled
                              ? (val) {
                                  setState(() {
                                    _hasUserInteracted = true;
                                    field.didChange(val);
                                  });
                                }
                              : null,
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              text: widget.label,
                              style: TextStyle(
                                color: colorScheme.onSurface,
                                fontSize: 16,
                              ),
                              children: widget.required
                                  ? [
                                      const TextSpan(
                                        text: ' *',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ]
                                  : [],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (field.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, left: 4.0),
                    child: Text(
                      field.errorText ?? '',
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
