import 'package:careconnect_admin/models/qualification.dart';
import 'package:careconnect_admin/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'employee.g.dart';

@JsonSerializable(explicitToJson: true)
class Employee {
  final DateTime hireDate;
  final DateTime? endDate;
  final String jobTitle;
  final DateTime modifiedDate;
  final User user;
  final Qualification? qualification;

  bool get employed => endDate == null;

  Employee({
    required this.hireDate,
    this.endDate,
    required this.jobTitle,
    required this.modifiedDate,
    required this.user,
    this.qualification,
  });

  /// Connect the generated [_$EmployeeFromJson] function to the `fromJson`
  /// factory.
  factory Employee.fromJson(Map<String, dynamic> json) =>
      _$EmployeeFromJson(json);

  /// Connect the generated [_$EmployeeToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$EmployeeToJson(this);
}
