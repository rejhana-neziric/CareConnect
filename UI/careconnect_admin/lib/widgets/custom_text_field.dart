import 'package:careconnect_admin/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

// final theme = Theme.of(context);
// final colorScheme = theme.colorScheme;

class CustomTextField extends StatelessWidget {
  final double width;
  final String name;
  final String label;
  final String? hintText;
  final String? prefixText;
  final String? Function(String?)? validator;
  final bool enabled;

  const CustomTextField({
    super.key,
    required this.width,
    required this.name,
    required this.label,
    this.hintText,
    this.prefixText,
    this.validator,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    // final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: SizedBox(
        width: width,
        child: FormBuilderField<String>(
          name: name,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (FormFieldState<String?> field) {
            final controller = TextEditingController(text: field.value);
            controller.selection = TextSelection.fromPosition(
              TextPosition(offset: controller.text.length),
            );
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
                  child: TextField(
                    controller: controller,
                    enabled: enabled,
                    onChanged: field.didChange,
                    decoration: InputDecoration(
                      labelText: label,
                      border: InputBorder.none,
                      hintText: hintText,
                      prefixText: prefixText,
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
