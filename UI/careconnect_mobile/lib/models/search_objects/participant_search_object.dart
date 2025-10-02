import 'package:careconnect_mobile/models/search_objects/participant_additional_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'participant_search_object.g.dart';

@JsonSerializable(explicitToJson: true)
class ParticipantSearchObject {
  String? fts;
  int? workshopId;
  String? userFirstNameGTE;
  String? userLastNameGTE;
  String? workshopNameGTE;
  String? attendanceStatusNameGTE;
  DateTime? registrationDateGTE;
  DateTime? registrationDateLTE;
  ParticipantAdditionalData? additionalData;
  int? userId;
  int? page;
  String? sortBy;
  bool? sortAscending;
  bool? includeTotalCount;
  bool? retrieveAll;

  ParticipantSearchObject({
    this.fts,
    this.workshopId,
    this.userFirstNameGTE,
    this.userLastNameGTE,
    this.workshopNameGTE,
    this.attendanceStatusNameGTE,
    this.registrationDateGTE,
    this.registrationDateLTE,
    this.additionalData,
    this.userId,
    this.page,
    this.sortBy,
    this.sortAscending,
    this.includeTotalCount,
    this.retrieveAll,
  });

  factory ParticipantSearchObject.fromJson(Map<String, dynamic> json) =>
      _$ParticipantSearchObjectFromJson(json);

  Map<String, dynamic> toJson() => _$ParticipantSearchObjectToJson(this);
}
