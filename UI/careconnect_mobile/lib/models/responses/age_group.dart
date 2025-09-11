import 'package:json_annotation/json_annotation.dart';

part 'age_group.g.dart';

@JsonSerializable(explicitToJson: true)
class AgeGroup {
  final String category;
  final int number;

  AgeGroup({required this.category, required this.number});

  factory AgeGroup.fromJson(Map<String, dynamic> json) =>
      _$AgeGroupFromJson(json);

  Map<String, dynamic> toJson() => _$AgeGroupToJson(this);
}
