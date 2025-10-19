import 'package:json_annotation/json_annotation.dart';

part 'workshop_update_request.g.dart'; // Don't open or edit this

@JsonSerializable()
class WorkshopUpdateRequest {
  String? name;
  String? description;
  String? workshopType;
  DateTime? date;
  double? price;
  int? maxParticipants;
  int? participants;
  String? notes;

  WorkshopUpdateRequest({
    this.name,
    this.description,
    this.workshopType,
    this.date,
    this.price,
    this.maxParticipants,
    this.participants,
    this.notes,
  });

  factory WorkshopUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$WorkshopUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$WorkshopUpdateRequestToJson(this);
}
