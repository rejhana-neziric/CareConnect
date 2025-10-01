import 'package:careconnect_mobile/models/search_objects/appointment_additional_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'appointment_search_object.g.dart';

@JsonSerializable(explicitToJson: true)
class AppointmentSearchObject {
  String? fts;
  String? appointmentType;
  DateTime? dateGTE;
  DateTime? dateLTE;
  String? attendanceStatusName;
  String? employeeFirstName;
  String? employeeLastName;
  String? startTime;
  String? endTime;
  String? status;
  String? childFirstName;
  String? childLastName;
  int? clientId;
  int? childId;
  String? clientUsername;
  int? serviceTypeId;
  String? serviceNameGTE;
  int? employeeAvailabilityId;
  DateTime? date;
  AppointmentAdditionalData? additionalData;
  int? page;
  String? sortBy;
  bool? sortAscending;
  bool? includeTotalCount;

  AppointmentSearchObject({
    this.fts,
    this.appointmentType,
    this.dateGTE,
    this.dateLTE,
    this.attendanceStatusName,
    this.employeeFirstName,
    this.employeeLastName,
    this.startTime,
    this.endTime,
    this.status,
    this.childFirstName,
    this.childLastName,
    this.clientId,
    this.childId,
    this.clientUsername,
    this.serviceTypeId,
    this.serviceNameGTE,
    this.employeeAvailabilityId,
    this.date,
    this.additionalData,
    this.page,
    this.sortAscending,
    this.includeTotalCount,
    this.sortBy,
  });

  factory AppointmentSearchObject.fromJson(Map<String, dynamic> json) =>
      _$AppointmentSearchObjectFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentSearchObjectToJson(this);
}
