import 'package:careconnect_mobile/models/search_objects/employee_availability_additional_data.dart';

import 'package:json_annotation/json_annotation.dart';

part 'employee_availability_search_object.g.dart';

@JsonSerializable(explicitToJson: true)
class EmployeeAvailabilitySearchObject {
  String? fts;
  String? dayOfWeek;
  String? startTime;
  String? endTime;
  String? employeeFirstNameGTE;
  String? employeeLastNameGTE;
  String? serviceNameGTE;
  int? employeeId;
  int? serviceId;
  int? page;
  String? sortBy;
  bool? sortAscending;

  bool? includeTotalCount;
  EmployeeAvailabilityAdditionalData? additionalData;

  EmployeeAvailabilitySearchObject({
    this.fts,
    this.dayOfWeek,
    this.startTime,
    this.endTime,
    this.employeeFirstNameGTE,
    this.employeeLastNameGTE,
    this.serviceNameGTE,
    this.employeeId,
    this.serviceId,
    this.page,
    this.sortBy,
    this.sortAscending,
    this.additionalData,
    this.includeTotalCount,
  });

  factory EmployeeAvailabilitySearchObject.fromJson(
    Map<String, dynamic> json,
  ) => _$EmployeeAvailabilitySearchObjectFromJson(json);

  Map<String, dynamic> toJson() =>
      _$EmployeeAvailabilitySearchObjectToJson(this);
}
