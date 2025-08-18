import 'package:careconnect_admin/models/responses/workshop_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'workshop.g.dart'; // Don't open or edit this

@JsonSerializable()
class Workshop {
  final int workshopId;
  final String name;
  final String description;
  final String status;
  final DateTime startDate;
  final DateTime? endDate;
  final double? price;
  final double? memberPrice;
  final int? maxParticipants;
  final int? participants;
  final String? notes;
  final DateTime modifiedDate;
  final WorkshopType workshopType;

  Workshop({
    required this.workshopId,
    required this.name,
    required this.description,
    required this.status,
    required this.startDate,
    this.endDate,
    this.price,
    this.memberPrice,
    this.maxParticipants,
    this.participants,
    this.notes,
    required this.modifiedDate,
    required this.workshopType,
  });

  factory Workshop.fromJson(Map<String, dynamic> json) =>
      _$WorkshopFromJson(json);

  Map<String, dynamic> toJson() => _$WorkshopToJson(this);
}
