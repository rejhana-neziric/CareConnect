import 'package:flutter/material.dart';

class CustomDropdownFilter extends StatelessWidget {
  const CustomDropdownFilter({
    super.key,
    required this.name,
    required this.selectedValue,
    required this.options,
    required this.onChanged,
  });

  final String name;
  final String? selectedValue;
  final Map<String, String?> options;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        //border: Border.all(color: colorScheme.primaryContainer, width: 2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          borderRadius: BorderRadius.circular(8),

          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600),
          isExpanded: true,
          style: TextStyle(color: colorScheme.onPrimaryContainer, fontSize: 14),
          dropdownColor: colorScheme.surfaceContainerLowest,
          items: options.entries.map((entry) {
            return DropdownMenuItem<String>(
              value: entry.value,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        entry.key,
                        style: TextStyle(
                          color: colorScheme.onPrimaryContainer,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            onChanged(newValue);
          },
          selectedItemBuilder: (BuildContext context) {
            return options.entries.map((entry) {
              return Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        entry.key,
                        style: TextStyle(
                          color: colorScheme.onPrimaryContainer,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }
}
