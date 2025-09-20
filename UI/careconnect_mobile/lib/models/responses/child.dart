import 'package:careconnect_mobile/models/responses/diagnosis.dart';
import 'package:json_annotation/json_annotation.dart';

part 'child.g.dart';

@JsonSerializable(explicitToJson: true)
class Child {
  final int childId;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final String gender;
  final List<Diagnosis> diagnoses;

  Child({
    required this.childId,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.gender,
    required this.diagnoses,
  });

  int get age {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  factory Child.fromJson(Map<String, dynamic> json) => _$ChildFromJson(json);

  Map<String, dynamic> toJson() => _$ChildToJson(this);
}
