import 'package:json_annotation/json_annotation.dart';

part 'qualification.g.dart'; // Don't open or edit this

@JsonSerializable()
class Qualification {
  final String name;
  final String instituteName;
  final DateTime procurementYear;
  final DateTime modifiedDate;

  Qualification({
    required this.name,
    required this.instituteName,
    required this.procurementYear,
    required this.modifiedDate,
  });

  /// Connect the generated [_$EmployeeFromJson] function to the `fromJson`
  /// factory.
  factory Qualification.fromJson(Map<String, dynamic> json) =>
      _$QualificationFromJson(json);

  /// Connect the generated [_$QualificationToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$QualificationToJson(this);
}
