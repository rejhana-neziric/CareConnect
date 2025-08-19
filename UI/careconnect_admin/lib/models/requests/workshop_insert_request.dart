import 'package:json_annotation/json_annotation.dart';

part 'workshop_insert_request.g.dart'; // Don't open or edit this

@JsonSerializable()
class WorkshopInsertRequest {
  String name;
  String description;
  String workshopType;
  DateTime startDate;
  DateTime? endDate;
  double? price;
  double? memberPrice;
  int? maxParticipants;
  int? participants;
  String? notes;

  WorkshopInsertRequest({
    required this.name,
    required this.description,
    required this.workshopType,
    required this.startDate,
    this.endDate,
    this.price,
    this.memberPrice,
    this.maxParticipants,
    this.participants,
    this.notes,
  });

  factory WorkshopInsertRequest.fromJson(Map<String, dynamic> json) =>
      _$WorkshopInsertRequestFromJson(json);

  Map<String, dynamic> toJson() => _$WorkshopInsertRequestToJson(this);
}
