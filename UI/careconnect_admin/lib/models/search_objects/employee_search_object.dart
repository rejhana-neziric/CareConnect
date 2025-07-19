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

  Map<String, dynamic> toJson() => {
    'fts': fts,
    'firstNameGTE': firstNameGTE,
    'lastNameGTE': lastNameGTE,
    'email': email,
    'jobTitle': jobTitle,
    'hireDateGTE': hireDateGTE?.toIso8601String(),
    'hireDateLTE': hireDateLTE?.toIso8601String(),
    'employed': employed?.toString(),
    'page': page?.toString(),
    'sortBy': sortBy,
    'sortAscending': sortAscending,
    'additionalData': additionalData?.toJson(),
    'includeTotalCount': includeTotalCount?.toString(),
  };
}
