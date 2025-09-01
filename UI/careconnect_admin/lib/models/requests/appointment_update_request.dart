import 'package:json_annotation/json_annotation.dart';

part 'appointment_update_request.g.dart';

@JsonSerializable()
class AppointmentUpdateRequest {
  int? employeeAvailabilityId;
  String? appointmentType;
  int? attendanceStatusId;
  DateTime? date;
  String? description;
  String? note;

  AppointmentUpdateRequest({
    this.employeeAvailabilityId,
    this.appointmentType,
    this.attendanceStatusId,
    this.date,
    this.description,
    this.note,
  });

  factory AppointmentUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$AppointmentUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentUpdateRequestToJson(this);
}
