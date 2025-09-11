import 'package:careconnect_mobile/widgets/filter/filter_section.dart';

class FilterConfig {
  final List<FilterSection> sections;
  final String title;
  final String applyButtonText;
  final String clearAllText;

  FilterConfig({
    required this.sections,
    this.title = 'Filters',
    this.applyButtonText = 'Apply Filters',
    this.clearAllText = 'Clear all',
  });
}
