class ChildAgeGroup {
  final String category;
  final int number;

  ChildAgeGroup({required this.category, required this.number});

  factory ChildAgeGroup.fromJson(Map<String, dynamic> json) {
    return ChildAgeGroup(category: json['category'], number: json['number']);
  }
}
