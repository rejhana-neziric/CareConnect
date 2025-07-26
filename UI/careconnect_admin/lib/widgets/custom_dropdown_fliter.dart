import 'package:careconnect_admin/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomDropdownFliter extends StatelessWidget {
  const CustomDropdownFliter({
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
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.dustyRose, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600),
          isExpanded: true,
          style: TextStyle(color: Colors.black87, fontSize: 14),
          dropdownColor: Colors.white,
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
                          color: AppColors.mauveGray,
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
            //if (newValue != null) {
            onChanged(newValue);
            //}
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
                          color: Colors.black87,
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
