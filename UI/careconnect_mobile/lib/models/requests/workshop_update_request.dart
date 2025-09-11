import 'package:json_annotation/json_annotation.dart';

part 'workshop_update_request.g.dart'; // Don't open or edit this

@JsonSerializable()
class WorkshopUpdateRequest {
  String? name;
  String? description;
  String? workshopType;
  DateTime? startDate;
  DateTime? endDate;
  double? price;
  double? memberPrice;
  int? maxParticipants;
  int? participants;
  String? notes;

  WorkshopUpdateRequest({
    this.name,
    this.description,
    this.workshopType,
    this.startDate,
    this.endDate,
    this.price,
    this.memberPrice,
    this.maxParticipants,
    this.participants,
    this.notes,
  });

  factory WorkshopUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$WorkshopUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$WorkshopUpdateRequestToJson(this);
}
