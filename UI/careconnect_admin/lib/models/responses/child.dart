import 'package:json_annotation/json_annotation.dart';

part 'child.g.dart';

@JsonSerializable(explicitToJson: true)
class Child {
  final int childId;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final String gender;

  Child({
    required this.childId,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.gender,
  });

  factory Child.fromJson(Map<String, dynamic> json) => _$ChildFromJson(json);

  Map<String, dynamic> toJson() => _$ChildToJson(this);
}
