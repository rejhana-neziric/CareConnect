import 'package:careconnect_admin/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'employee.g.dart';

@JsonSerializable(explicitToJson: true)
class Employee {
  DateTime hireDate;
  DateTime? endDate;
  bool employed;
  String? jobTitle;
  User? user;

  Employee({
    required this.hireDate,
    this.endDate,
    required this.employed,
    this.jobTitle,
    this.user,
  });

  /// Connect the generated [_$EmployeeFromJson] function to the `fromJson`
  /// factory.
  factory Employee.fromJson(Map<String, dynamic> json) =>
      _$EmployeeFromJson(json);

  /// Connect the generated [_$EmployeeToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$EmployeeToJson(this);
}
