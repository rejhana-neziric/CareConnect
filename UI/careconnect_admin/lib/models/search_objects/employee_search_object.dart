import 'package:careconnect_admin/models/search_objects/employee_additional_data.dart';

import 'package:json_annotation/json_annotation.dart';

part 'employee_search_object.g.dart';

@JsonSerializable(explicitToJson: true)
class EmployeeSearchObject {
  String? fts;
  String? firstNameGTE;
  String? lastNameGTE;
  String? email;
  String? jobTitle;
  DateTime? hireDateGTE;
  DateTime? hireDateLTE;
  bool? employed;
  int? page;
  String? sortBy;
  bool? sortAscending;
  EmployeeAdditionalData? additionalData;
  bool? includeTotalCount;

  EmployeeSearchObject({
    this.fts,
    this.firstNameGTE,
    this.lastNameGTE,
    this.email,
    this.jobTitle,
    this.hireDateGTE,
    this.hireDateLTE,
    this.employed,
    this.page,
    this.sortBy,
    this.sortAscending,
    this.additionalData,
    this.includeTotalCount,
  });

  factory EmployeeSearchObject.fromJson(Map<String, dynamic> json) =>
      _$EmployeeSearchObjectFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeSearchObjectToJson(this);
}
