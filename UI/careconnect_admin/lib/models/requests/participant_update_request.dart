import 'package:json_annotation/json_annotation.dart';

part 'participant_update_request.g.dart';

@JsonSerializable()
class ParticipantUpdateRequest {
  int attendanceStatusId;

  ParticipantUpdateRequest({required this.attendanceStatusId});

  factory ParticipantUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$ParticipantUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ParticipantUpdateRequestToJson(this);
}
