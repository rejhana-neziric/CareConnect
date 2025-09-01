import 'package:json_annotation/json_annotation.dart';

part 'appointment_insert_request.g.dart';

@JsonSerializable()
class AppointmentInsertRequest {
  int userId;
  int employeeAvailabilityId;
  String appointmentType;
  int attendanceStatusId;
  DateTime date;
  String? description;
  String? note;

  AppointmentInsertRequest({
    required this.userId,
    required this.employeeAvailabilityId,
    required this.appointmentType,
    required this.attendanceStatusId,
    required this.date,
    this.description,
    this.note,
  });

  factory AppointmentInsertRequest.fromJson(Map<String, dynamic> json) =>
      _$AppointmentInsertRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentInsertRequestToJson(this);
}
