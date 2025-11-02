import 'package:careconnect_admin/models/responses/attendance_status.dart';
import 'package:careconnect_admin/models/responses/child.dart';
import 'package:careconnect_admin/models/responses/user.dart';
import 'package:careconnect_admin/models/responses/workshop.dart';
import 'package:json_annotation/json_annotation.dart';

part 'participant.g.dart'; // Don't open or edit this

@JsonSerializable()
class Participant {
  int participantId;
  DateTime registrationDate;
  DateTime modifiedDate;
  int attendanceStatusId;
  AttendanceStatus? attendanceStatus;
  User? user;
  Workshop? workshop;
  Child? child;

  Participant({
    required this.participantId,
    required this.registrationDate,
    required this.modifiedDate,
    this.attendanceStatus,
    required this.attendanceStatusId,
    this.user,
    this.workshop,
    this.child,
  });

  factory Participant.fromJson(Map<String, dynamic> json) =>
      _$ParticipantFromJson(json);

  Map<String, dynamic> toJson() => _$ParticipantToJson(this);
}
