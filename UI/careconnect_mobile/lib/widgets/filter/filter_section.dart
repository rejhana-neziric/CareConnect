import 'package:careconnect_mobile/widgets/filter/filter_option.dart';

class FilterSection {
  final String title;
  final List<FilterOption> options;
  final bool allowMultipleSelection;
  final bool isPrice;

  FilterSection({
    required this.title,
    required this.options,
    this.allowMultipleSelection = true,
    this.isPrice = false,
  });
}
