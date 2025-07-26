import 'package:careconnect_admin/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class CustomDateField extends StatelessWidget {
  final double width;
  final String name;
  final String label;
  final String? Function(DateTime?)? validator;
  final bool enabled;

  const CustomDateField({
    super.key,
    required this.width,
    required this.name,
    required this.label,
    this.validator,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
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
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 17,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.dustyRose, width: 2),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
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
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        field.value != null
                            ? DateFormat('dd/MM/yyyy').format(field.value!)
                            : label,
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
