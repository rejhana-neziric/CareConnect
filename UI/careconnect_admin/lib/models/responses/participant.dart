import 'package:careconnect_admin/models/responses/attendance_status.dart';
import 'package:careconnect_admin/models/responses/child.dart';
import 'package:careconnect_admin/models/responses/user.dart';
import 'package:careconnect_admin/models/responses/workshop.dart';
import 'package:json_annotation/json_annotation.dart';

part 'participant.g.dart'; // Don't open or edit this

@JsonSerializable()
class Participant {
  DateTime registrationDate;
  DateTime modifiedDate;
  AttendanceStatus attendanceStatus;
  User? user;
  Workshop? workshop;
  Child? child;

  Participant({
    required this.registrationDate,
    required this.modifiedDate,
    required this.attendanceStatus,
    this.user,
    this.workshop,
    this.child,
  });

  factory Participant.fromJson(Map<String, dynamic> json) =>
      _$ParticipantFromJson(json);

  Map<String, dynamic> toJson() => _$ParticipantToJson(this);
}
