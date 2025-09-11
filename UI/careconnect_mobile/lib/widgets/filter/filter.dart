import 'package:careconnect_mobile/widgets/filter/filter_config.dart';
import 'package:careconnect_mobile/widgets/filter/filter_option.dart';
import 'package:careconnect_mobile/widgets/filter/filter_section.dart';
import 'package:flutter/material.dart';

class FilterWidget<T> extends StatefulWidget {
  final FilterConfig config;
  final Function(Map<String, List<String>>) onApply;
  final VoidCallback? onClearAll;

  const FilterWidget({
    Key? key,
    required this.config,
    required this.onApply,
    this.onClearAll,
  }) : super(key: key);

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  late List<FilterSection> sections;

  @override
  void initState() {
    super.initState();
    sections = List.from(widget.config.sections);
  }

  void _toggleOption(int sectionIndex, int optionIndex) {
    setState(() {
      final section = sections[sectionIndex];
      final option = section.options[optionIndex];

      if (!section.allowMultipleSelection) {
        // Single selection: deselect all others in this section
        for (int i = 0; i < section.options.length; i++) {
          section.options[i] = section.options[i].copyWith(
            isSelected: i == optionIndex ? !option.isSelected : false,
          );
        }
      } else {
        // Multiple selection: toggle this option
        section.options[optionIndex] = option.copyWith(
          isSelected: !option.isSelected,
        );
      }
    });
  }

  void _clearAll() {
    setState(() {
      for (var section in sections) {
        for (int i = 0; i < section.options.length; i++) {
          section.options[i] = section.options[i].copyWith(isSelected: false);
        }
      }
    });
    if (widget.onClearAll != null) {
      widget.onClearAll!();
    }
  }

  // void _applyFilters() {
  //   Map<String, List<String>> selectedFilters = {};

  //   for (var section in sections) {
  //     List<String> selectedOptions = section.options
  //         .where((option) => option.isSelected)
  //         .map((option) => option.key)
  //         .toList();

  //     if (selectedOptions.isNotEmpty) {
  //       selectedFilters[section.title.toLowerCase()] = selectedOptions;
  //     }
  //   }

  //   widget.onApply(selectedFilters);
  //   Navigator.of(context).pop();
  // }

  void _applyFilters() {
    Map<String, List<String>> selectedFilters = {};

    for (var section in sections) {
      List<String> selectedOptions = section.options
          .where((option) => option.isSelected)
          .map((option) => option.key.toString()) // Convert to string
          .toList();

      if (selectedOptions.isNotEmpty) {
        selectedFilters[section.title.toLowerCase()] = selectedOptions;
      }
    }

    widget.onApply(selectedFilters);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow, //Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8),
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.arrow_back_ios, size: 20),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.config.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: _clearAll,
                  child: Text(
                    widget.config.clearAllText,
                    style: TextStyle(
                      color: colorScheme.primary, //Color(0xFFFF6B35),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Filter sections
          Flexible(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: sections.asMap().entries.map((sectionEntry) {
                    int sectionIndex = sectionEntry.key;
                    FilterSection section = sectionEntry.value;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          section.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface, //Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: section.options.asMap().entries.map((
                            optionEntry,
                          ) {
                            int optionIndex = optionEntry.key;
                            FilterOption option = optionEntry.value;

                            return GestureDetector(
                              onTap: () =>
                                  _toggleOption(sectionIndex, optionIndex),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: option.isSelected
                                      ? colorScheme
                                            .primary //const Color(0xFFFF6B35)
                                      : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  option.label,
                                  style: TextStyle(
                                    color: option.isSelected
                                        ? Colors.white
                                        : Colors.grey[700],
                                    fontSize: 14,
                                    fontWeight: option.isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          // Apply button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _applyFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    colorScheme.primaryContainer, //const Color(0xFFFF6B35),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
              ),
              child: Text(
                widget.config.applyButtonText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
