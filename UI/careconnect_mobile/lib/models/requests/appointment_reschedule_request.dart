import 'package:json_annotation/json_annotation.dart';

part 'appointment_reschedule_request.g.dart';

@JsonSerializable()
class AppointmentRescheduleRequest {
  int? employeeAvailabilityId;
  DateTime? date;

  AppointmentRescheduleRequest({this.employeeAvailabilityId, this.date});

  factory AppointmentRescheduleRequest.fromJson(Map<String, dynamic> json) =>
      _$AppointmentRescheduleRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentRescheduleRequestToJson(this);
}
