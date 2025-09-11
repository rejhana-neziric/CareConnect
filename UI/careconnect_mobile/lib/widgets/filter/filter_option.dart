class FilterOption<T> {
  T key; // can be String, int, bool...
  String label;
  bool isSelected;

  FilterOption({
    required this.key,
    required this.label,
    this.isSelected = false,
  });

  FilterOption<T> copyWith({bool? isSelected}) {
    return FilterOption<T>(
      key: key,
      label: label,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
