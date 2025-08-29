import 'package:careconnect_admin/models/requests/employee_availability_insert_request.dart';
import 'package:careconnect_admin/models/requests/employee_availability_update_request.dart';
import 'package:json_annotation/json_annotation.dart';

part 'employee_availability_changes.g.dart';

@JsonSerializable()
class EmployeeAvailabilityChanges {
  final List<EmployeeAvailabilityInsertRequest> toCreate;
  final Map<int, EmployeeAvailabilityUpdateRequest> toUpdate;
  final List<int> toDelete;

  EmployeeAvailabilityChanges({
    required this.toCreate,
    required this.toUpdate,
    required this.toDelete,
  });

  bool get hasChanges =>
      toCreate.isNotEmpty || toUpdate.isNotEmpty || toDelete.isNotEmpty;

  factory EmployeeAvailabilityChanges.fromJson(Map<String, dynamic> json) =>
      _$EmployeeAvailabilityChangesFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeAvailabilityChangesToJson(this);
}
