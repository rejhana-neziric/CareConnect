import 'package:careconnect_mobile/models/requests/qualification_insert_request.dart';
import 'package:careconnect_mobile/models/requests/user_insert_request.dart';

import 'package:json_annotation/json_annotation.dart';

part 'employee_insert_request.g.dart'; // Don't open or edit this

@JsonSerializable()
class EmployeeInsertRequest {
  final DateTime hireDate;
  final String jobTitle;
  final UserInsertRequest user;
  final QualificationInsertRequest? qualification;

  EmployeeInsertRequest({
    required this.hireDate,
    required this.jobTitle,
    required this.user,
    this.qualification,
  });

  factory EmployeeInsertRequest.fromJson(Map<String, dynamic> json) =>
      _$EmployeeInsertRequestFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeInsertRequestToJson(this);
}
