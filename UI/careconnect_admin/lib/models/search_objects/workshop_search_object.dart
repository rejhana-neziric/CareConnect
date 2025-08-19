import 'package:json_annotation/json_annotation.dart';

part 'workshop_search_object.g.dart';

@JsonSerializable(explicitToJson: true)
class WorkshopSearchObject {
  String? fts;
  final String? nameGTE;
  final String? status;
  final DateTime? startDateGTE;
  final DateTime? startDateLTE;
  final DateTime? endDateGTE;
  final DateTime? endDateLTE;
  final double? price;
  final double? memberPrice;
  final int? maxParticipants;
  final int? participants;
  final String? workshopType;
  int? page;
  String? sortBy;
  bool? sortAscending;
  bool? includeTotalCount;
  bool? retrieveAll;

  WorkshopSearchObject({
    this.fts,
    this.nameGTE,
    this.status,
    this.startDateGTE,
    this.startDateLTE,
    this.endDateGTE,
    this.endDateLTE,
    this.price,
    this.memberPrice,
    this.maxParticipants,
    this.participants,
    this.workshopType,

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
