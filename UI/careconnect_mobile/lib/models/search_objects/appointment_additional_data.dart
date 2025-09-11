import 'package:json_annotation/json_annotation.dart';

part 'appointment_additional_data.g.dart';

@JsonSerializable(explicitToJson: true)
class AppointmentAdditionalData {
  bool? isClientsChildIncluded;
  bool? isEmployeeAvailabilityIncluded;
  bool? isAttendanceStatusIncluded;

  AppointmentAdditionalData({
    this.isClientsChildIncluded,
    this.isEmployeeAvailabilityIncluded,
    this.isAttendanceStatusIncluded,
  });

  factory AppointmentAdditionalData.fromJson(Map<String, dynamic> json) =>
      _$AppointmentAdditionalDataFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentAdditionalDataToJson(this);
}
