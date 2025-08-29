import 'package:careconnect_admin/models/time_slot.dart';
import 'package:json_annotation/json_annotation.dart';

part 'employee_availability_update_request.g.dart';

@JsonSerializable()
class EmployeeAvailabilityUpdateRequest {
  final int? serviceId;
  final String? dayOfWeek;
  final String? startTime;
  final String? endTime;

  EmployeeAvailabilityUpdateRequest({
    this.serviceId,
    this.dayOfWeek,
    this.startTime,
    this.endTime,
  });

  factory EmployeeAvailabilityUpdateRequest.fromJson(
    Map<String, dynamic> json,
  ) => _$EmployeeAvailabilityUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$EmployeeAvailabilityUpdateRequestToJson(this);

  factory EmployeeAvailabilityUpdateRequest.fromTimeSlot(
    TimeSlot timeSlot,
    int employeeId,
  ) {
    return EmployeeAvailabilityUpdateRequest(
      dayOfWeek: timeSlot.day,
      startTime:
          '${timeSlot.start.hour.toString().padLeft(2, '0')}:${timeSlot.start.minute.toString().padLeft(2, '0')}',
      endTime:
          '${timeSlot.end.hour.toString().padLeft(2, '0')}:${timeSlot.end.minute.toString().padLeft(2, '0')}',
      serviceId: timeSlot.service?.serviceId,
    );
  }
}
