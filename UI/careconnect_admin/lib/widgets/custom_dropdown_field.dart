import 'package:careconnect_admin/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomDropdownField<T> extends StatelessWidget {
  final double width;
  final String name;
  final String label;
  final List<DropdownMenuItem<T>> items;
  final String? Function(T?)? validator;
  final bool enabled;

  const CustomDropdownField({
    super.key,
    required this.width,
    required this.name,
    required this.label,
    required this.items,
    this.validator,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: SizedBox(
        width: width,
        child: FormBuilderField<T>(
          name: name,
          validator: validator,
          autovalidateMode: AutovalidateMode.disabled,
          builder: (FormFieldState<T?> field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.dustyRose, width: 2),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: DropdownButton<T>(
                    isExpanded: true,
                    value: field.value,
                    onChanged: enabled ? field.didChange : null,
                    hint: Text(label),
                    underline: const SizedBox(),
                    items: items,
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
