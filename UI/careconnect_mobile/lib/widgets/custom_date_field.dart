import 'package:careconnect_mobile/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateField extends StatefulWidget {
  final DateTime? initialDate;
  final String label;
  final ValueChanged<DateTime?> onDateSelected; // <-- allow null now
  final DateTime firstDate;
  final DateTime lastDate;
  final Color accentColor;
  final FormFieldValidator<DateTime?>? validator; // <-- validator supports null

  CustomDateField({
    super.key,
    this.initialDate,
    required this.onDateSelected,
    this.label = "Select Date",
    DateTime? firstDate,
    DateTime? lastDate,
    this.accentColor = const Color(0xFF673AB7),
    this.validator,
  }) : firstDate = firstDate ?? DateTime(1900),
       lastDate = lastDate ?? DateTime.now();

  @override
  State<CustomDateField> createState() => _CustomDateFieldState();
}

class _CustomDateFieldState extends State<CustomDateField> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  String _formatDate(DateTime date) {
    return DateFormat('d. MM. yyyy.').format(date);
  }

  Future<void> _pickDate(
    ThemeData themeData,
    FormFieldState<DateTime?> field,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedDate ??
          DateTime.now().subtract(const Duration(days: 365 * 20)),
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.mauveGray,
              onPrimary: AppColors.white,
              onSurface: AppColors.accentDeepMauve,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.accentMauveGray,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
      field.didChange(picked);
      widget.onDateSelected(picked);
    }
  }

  void _clearDate(FormFieldState<DateTime?> field) {
    setState(() => _selectedDate = null);
    field.didChange(null);
    widget.onDateSelected(null);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return FormField<DateTime?>(
      initialValue: _selectedDate,
      validator: widget.validator,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: field.hasError
                      ? Colors.red
                      : colorScheme.primaryContainer,
                ),
                borderRadius: BorderRadius.circular(12),
                color: colorScheme.surfaceContainerLow,
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, color: colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () => _pickDate(theme, field),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          _selectedDate != null
                              ? '${widget.label}: ${_formatDate(_selectedDate!)}'
                              : widget.label,
                          style: TextStyle(
                            fontSize: 16,
                            color: _selectedDate != null
                                ? colorScheme.onSurface
                                : Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (_selectedDate != null)
                    IconButton(
                      icon: const Icon(Icons.clear, color: Colors.red),
                      tooltip: "Clear date",
                      onPressed: () => _clearDate(field),
                    )
                  else
                    Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
                ],
              ),
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 12),
                child: Text(
                  field.errorText!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }
}
