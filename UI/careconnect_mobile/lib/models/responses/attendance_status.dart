import 'package:json_annotation/json_annotation.dart';

part 'attendance_status.g.dart';

@JsonSerializable()
class AttendanceStatus {
  int? attendanceStatusId;
  String? name;

  AttendanceStatus({this.attendanceStatusId, this.name});

  factory AttendanceStatus.fromJson(Map<String, dynamic> json) =>
      _$AttendanceStatusFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceStatusToJson(this);
}
