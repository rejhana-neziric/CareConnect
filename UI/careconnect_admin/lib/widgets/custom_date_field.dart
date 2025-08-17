import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class CustomDateField extends StatelessWidget {
  final double width;
  final String name;
  final String label;
  final String? Function(DateTime?)? validator;
  final bool enabled;
  final bool required;

  const CustomDateField({
    super.key,
    required this.width,
    required this.name,
    required this.label,
    this.validator,
    this.enabled = true,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: SizedBox(
        width: width,
        child: FormBuilderField<DateTime>(
          name: name,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: colorScheme.primaryContainer,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: colorScheme.surfaceContainerLowest,
                  ),
                  child: InkWell(
                    onTap: enabled
                        ? () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: field.value ?? DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) field.didChange(picked);
                          }
                        : null,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        label: RichText(
                          text: TextSpan(
                            text: label,
                            style: TextStyle(
                              color: colorScheme.onSurface,
                              fontSize: 16,
                            ),
                            children: required
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
                        filled: true,
                        fillColor: colorScheme.surfaceContainerLowest,
                      ),
                      child: Text(
                        field.value != null
                            ? DateFormat('dd/MM/yyyy').format(field.value!)
                            : '',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                if (field.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, left: 4.0),
                    child: Text(
                      field.errorText ?? '',
                      style: TextStyle(color: colorScheme.error, fontSize: 12),
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
