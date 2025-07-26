import 'package:json_annotation/json_annotation.dart';

part 'gender_group.g.dart';

@JsonSerializable(explicitToJson: true)
class GenderGroup {
  final String gender;
  final int number;

  GenderGroup({required this.gender, required this.number});

  factory GenderGroup.fromJson(Map<String, dynamic> json) =>
      _$GenderGroupFromJson(json);

  Map<String, dynamic> toJson() => _$GenderGroupToJson(this);
}
