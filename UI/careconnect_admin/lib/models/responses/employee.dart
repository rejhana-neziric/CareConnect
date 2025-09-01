import 'package:careconnect_admin/models/responses/qualification.dart';
import 'package:careconnect_admin/models/responses/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'employee.g.dart';

@JsonSerializable(explicitToJson: true)
class Employee {
  final DateTime hireDate;
  final DateTime? endDate;
  final String jobTitle;
  final DateTime modifiedDate;
  final User? user;
  final Qualification? qualification;
  // List<EmployeeAvailability> employeeAvailabilities;

  bool get employed => endDate == null;

  Employee({
    required this.hireDate,
    this.endDate,
    required this.jobTitle,
    required this.modifiedDate,
    this.user,
    this.qualification,
    // required this.employeeAvailabilities,
  });

  factory Employee.fromJson(Map<String, dynamic> json) =>
      _$EmployeeFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeToJson(this);
}
