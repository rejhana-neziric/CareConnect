import 'package:careconnect_admin/models/requests/qualification_update_request.dart';
import 'package:careconnect_admin/models/requests/user_update_request.dart';
import 'package:json_annotation/json_annotation.dart';

part 'employee_update_request.g.dart'; // Don't open or edit this

@JsonSerializable()
class EmployeeUpdateRequest {
  final String? jobTitle;
  final UserUpdateRequest? user;
  final QualificationUpdateRequest? qualification;

  EmployeeUpdateRequest({this.jobTitle, this.user, this.qualification});

  /// Connect the generated [_$UserInsertRequestFromJson] function to the `fromJson`
  /// factory.
  factory EmployeeUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$EmployeeUpdateRequestFromJson(json);

  /// Connect the generated [_$UserToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$EmployeeUpdateRequestToJson(this);
}
