import 'package:json_annotation/json_annotation.dart';

part 'workshop_type.g.dart'; // Don't open or edit this

@JsonSerializable()
class WorkshopType {
  final int workshopTypeId;
  final String name;
  final String? description;
  final DateTime modifiedDate;

  WorkshopType({
    required this.workshopTypeId,
    required this.name,
    this.description,
    required this.modifiedDate,
  });

  factory WorkshopType.fromJson(Map<String, dynamic> json) =>
      _$WorkshopTypeFromJson(json);

  Map<String, dynamic> toJson() => _$WorkshopTypeToJson(this);
}
