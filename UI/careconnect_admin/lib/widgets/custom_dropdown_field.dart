import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomDropdownField<T> extends StatelessWidget {
  final double width;
  final String name;
  final String label;
  final List<DropdownMenuItem<T>> items;
  final String? Function(T?)? validator;
  final bool enabled;
  final bool required;
  final T? initialValue;
  final void Function(T?)? onChanged;

  const CustomDropdownField({
    super.key,
    required this.width,
    required this.name,
    required this.label,
    required this.items,
    this.validator,
    this.enabled = true,
    this.required = false,
    this.initialValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: SizedBox(
        width: width,
        child: FormBuilderField<T>(
          name: name,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator:
              validator ??
              (required
                  ? (value) {
                      if (value == null) {
                        return '$label is required';
                      }
                      return null;
                    }
                  : null),
          builder: (FormFieldState<T?> field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InputDecorator(
                  decoration: InputDecoration(
                    label: RichText(
                      text: TextSpan(
                        text: label,
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: 16,
                        ),
                        children: required
                            ? [
                                TextSpan(
                                  text: ' *',
                                  style: TextStyle(
                                    color: colorScheme.error,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ]
                            : [],
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: colorScheme.primaryContainer,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: colorScheme.primaryContainer,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerLowest,
                  ),
                  isEmpty: field.value == null,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<T>(
                      isExpanded: true,
                      isDense: true,
                      value: field.value,
                      onChanged: enabled
                          ? (value) {
                              field.didChange(value);
                              if (onChanged != null) {
                                onChanged!(value);
                              }
                            }
                          : null,
                      items: items,
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
