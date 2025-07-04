import 'dart:ffi';

import 'package:careconnect_admin/models/search_objects/employee_additional_data.dart';

class EmployeeSearchObject {
  String? fts;
  String? firstNameGTE;
  String? lastNameGTE;
  String? email;
  String? jobTitle;
  DateTime? hireDateGTE;
  DateTime? hireDateLTE;
  bool? employed;
  String? sortBy;
  bool? sortAscending;
  EmployeeAdditionalData? additionalData;

  EmployeeSearchObject({
    this.fts,
    this.firstNameGTE,
    this.lastNameGTE,
    this.email,
    this.jobTitle,
    this.hireDateGTE,
    this.hireDateLTE,
    this.employed,
    this.sortBy,
    this.sortAscending,
    this.additionalData,
  });

  Map<String, dynamic> toJson() => {
    'fts': fts,
    'firstNameGTE': firstNameGTE,
    'lastNameGTE': lastNameGTE,
    'email': email,
    'jobTitle': jobTitle,
    'hireDateGTE': hireDateGTE?.toIso8601String(),
    'hireDateLTE': hireDateLTE?.toIso8601String(),
    'employed': employed?.toString(),
    'sortBy': sortBy,
    'sortAscending': sortAscending,
    'additionalData': additionalData?.toJson(),
  };
}
