import 'package:json_annotation/json_annotation.dart';

part 'service_type.g.dart'; // Don't open or edit this

@JsonSerializable()
class ServiceType {
  final int serviceTypeId;
  final String name;
  final String? description;
  final int? numberOfServices;

  ServiceType({
    required this.serviceTypeId,
    required this.name,
    this.description,
    this.numberOfServices,
  });

  factory ServiceType.fromJson(Map<String, dynamic> json) =>
      _$ServiceTypeFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceTypeToJson(this);
}
