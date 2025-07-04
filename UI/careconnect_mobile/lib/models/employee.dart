import 'package:json_annotation/json_annotation.dart';

part 'employee.g.dart';

@JsonSerializable()
class Employee {
  DateTime? hireDate;
  String? jobTitle;

  Employee({this.hireDate, this.jobTitle});

  /// Connect the generated [_$PersonFromJson] function to the `fromJson`
  /// factory.
  factory Employee.fromJson(Map<String, dynamic> json) =>
      _$EmployeeFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$EmployeeToJson(this);
}
