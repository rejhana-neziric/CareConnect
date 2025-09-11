import 'package:json_annotation/json_annotation.dart';

part 'participant_additional_data.g.dart';

@JsonSerializable(explicitToJson: true)
class ParticipantAdditionalData {
  bool? isUserIncluded;
  bool? isWorkshopIncluded;
  bool? isAttendanceStatusIncluded;

  ParticipantAdditionalData({
    this.isUserIncluded,
    this.isWorkshopIncluded,
    this.isAttendanceStatusIncluded,
  });

  factory ParticipantAdditionalData.fromJson(Map<String, dynamic> json) =>
      _$ParticipantAdditionalDataFromJson(json);

  Map<String, dynamic> toJson() => _$ParticipantAdditionalDataToJson(this);
}
