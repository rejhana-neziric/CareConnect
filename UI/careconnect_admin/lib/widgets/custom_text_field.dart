import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomTextField extends StatefulWidget {
  final double width;
  final String name;
  final String label;
  final String? hintText;
  final String? prefixText;
  final int? maxLength;
  final int maxLines;
  final String? Function(String?)? validator;
  final bool enabled;
  final bool required;

  const CustomTextField({
    super.key,
    required this.width,
    required this.name,
    required this.label,
    this.hintText,
    this.prefixText,
    this.maxLength,
    this.maxLines = 1,
    this.validator,
    this.enabled = true,
    this.required = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late final TextEditingController _controller;
  bool _hasUserInteracted = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: SizedBox(
        width: widget.width,
        child: FormBuilderField<String>(
          name: widget.name,
          validator: widget.validator,
          autovalidateMode: _hasUserInteracted
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          builder: (field) {
            if (_controller.text != (field.value ?? '')) {
              _controller.text = field.value ?? '';
              _controller.selection = TextSelection.fromPosition(
                TextPosition(offset: _controller.text.length),
              );
            }
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
                  child: TextField(
                    controller: _controller,
                    maxLength: widget.maxLength,
                    maxLines: widget.maxLines,
                    enabled: widget.enabled,
                    onChanged: (val) {
                      if (!_hasUserInteracted) {
                        setState(() => _hasUserInteracted = true);
                      }
                      field.didChange(val);
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: widget.hintText,
                      prefixText: widget.prefixText,
                      label: RichText(
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
                      filled: true,
                      fillColor: colorScheme.surfaceContainerLowest,
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
