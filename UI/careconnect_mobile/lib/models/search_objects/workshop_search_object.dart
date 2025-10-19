import 'package:json_annotation/json_annotation.dart';

part 'workshop_search_object.g.dart';

@JsonSerializable(explicitToJson: true)
class WorkshopSearchObject {
  String? fts;
  final String? nameGTE;
  final String? status;
  final DateTime? dateGTE;
  final DateTime? dateLTE;
  final double? price;
  final int? maxParticipants;
  final int? participants;
  final String? workshopType;
  final int? participantId;
  int? page;
  String? sortBy;
  bool? sortAscending;
  bool? includeTotalCount;
  bool? retrieveAll;

  WorkshopSearchObject({
    this.fts,
    this.nameGTE,
    this.status,
    this.dateGTE,
    this.dateLTE,
    this.price,
    this.maxParticipants,
    this.participants,
    this.workshopType,
    this.participantId,

    this.page,
    this.sortBy,
    this.sortAscending,
    this.includeTotalCount,
    this.retrieveAll,
  });

  factory WorkshopSearchObject.fromJson(Map<String, dynamic> json) =>
      _$WorkshopSearchObjectFromJson(json);

  Map<String, dynamic> toJson() => _$WorkshopSearchObjectToJson(this);
}
