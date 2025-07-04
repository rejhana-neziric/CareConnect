import 'package:json_annotation/json_annotation.dart';

part 'attendance_status.g.dart';

@JsonSerializable()
class AttendanceStatus {
  int? attendanceStatusId;
  String? name;

  AttendanceStatus({this.attendanceStatusId, this.name});

  /// Connect the generated [_$PersonFromJson] function to the `fromJson`
  /// factory.
  factory AttendanceStatus.fromJson(Map<String, dynamic> json) =>
      _$AttendanceStatusFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$AttendanceStatusToJson(this);
}
