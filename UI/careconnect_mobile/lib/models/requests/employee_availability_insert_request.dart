// import 'package:careconnect_mobile/models/time_slot.dart';
// import 'package:json_annotation/json_annotation.dart';

// part 'employee_availability_insert_request.g.dart';

// @JsonSerializable()
// class EmployeeAvailabilityInsertRequest {
//   final int employeeId;
//   final int? serviceId;
//   final String dayOfWeek;
//   final String startTime;
//   final String endTime;

//   EmployeeAvailabilityInsertRequest({
//     required this.employeeId,
//     this.serviceId,
//     required this.dayOfWeek,
//     required this.startTime,
//     required this.endTime,
//   });

//   factory EmployeeAvailabilityInsertRequest.fromJson(
//     Map<String, dynamic> json,
//   ) => _$EmployeeAvailabilityInsertRequestFromJson(json);

//   Map<String, dynamic> toJson() =>
//       _$EmployeeAvailabilityInsertRequestToJson(this);

//   factory EmployeeAvailabilityInsertRequest.fromTimeSlot(
//     TimeSlot timeSlot,
//     int employeeId,
//   ) {
//     return EmployeeAvailabilityInsertRequest(
//       employeeId: employeeId,
//       dayOfWeek: timeSlot.day,
//       startTime:
//           '${timeSlot.start.hour.toString().padLeft(2, '0')}:${timeSlot.start.minute.toString().padLeft(2, '0')}',
//       endTime:
//           '${timeSlot.end.hour.toString().padLeft(2, '0')}:${timeSlot.end.minute.toString().padLeft(2, '0')}',
//       serviceId: timeSlot.service?.serviceId,
//     );
//   }

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;
//     return other is EmployeeAvailabilityInsertRequest &&
//         other.dayOfWeek == dayOfWeek &&
//         other.startTime == startTime &&
//         other.endTime == endTime &&
//         other.serviceId == serviceId;
//   }

//   @override
//   int get hashCode {
//     return dayOfWeek.hashCode ^
//         startTime.hashCode ^
//         endTime.hashCode ^
//         serviceId.hashCode;
//   }
// }
