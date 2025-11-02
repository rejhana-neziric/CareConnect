import 'package:json_annotation/json_annotation.dart';

part 'workshop.g.dart'; // Don't open or edit this

@JsonSerializable()
class Workshop {
  final int workshopId;
  final String name;
  final String description;
  final String status;
  final DateTime date;
  final double? price;
  final int? maxParticipants;
  final int? participants;
  final String? notes;
  final DateTime modifiedDate;
  final String workshopType;
  final bool paid;

  Workshop({
    required this.workshopId,
    required this.name,
    required this.description,
    required this.status,
    required this.date,
    this.price,
    this.maxParticipants,
    this.participants,
    this.notes,
    required this.modifiedDate,
    required this.workshopType,
    required this.paid,
  });

  factory Workshop.fromJson(Map<String, dynamic> json) =>
      _$WorkshopFromJson(json);

  Map<String, dynamic> toJson() => _$WorkshopToJson(this);
}
