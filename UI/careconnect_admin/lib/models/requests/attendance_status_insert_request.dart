import 'package:json_annotation/json_annotation.dart';

part 'attendance_status_insert_request.g.dart';

@JsonSerializable()
class AttendanceStatusInsertRequest {
  String name;

  AttendanceStatusInsertRequest({required this.name});

  factory AttendanceStatusInsertRequest.fromJson(Map<String, dynamic> json) =>
      _$AttendanceStatusInsertRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceStatusInsertRequestToJson(this);
}
