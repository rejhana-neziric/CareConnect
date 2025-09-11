import 'package:careconnect_mobile/widgets/filter/filter_option.dart';

class FilterSection {
  final String title;
  final List<FilterOption> options;
  final bool allowMultipleSelection;

  FilterSection({
    required this.title,
    required this.options,
    this.allowMultipleSelection = true,
  });
}
