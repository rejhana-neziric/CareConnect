import 'package:json_annotation/json_annotation.dart';

part 'service.g.dart'; // Don't open or edit this

@JsonSerializable()
class Service {
  final int serviceId;
  final String name;
  final String? description;
  final double? price;
  final double? memberPrice;
  final bool isActive;
  final DateTime modifiedDate;

  Service({
    required this.serviceId,
    required this.name,
    this.description,
    this.price,
    this.memberPrice,
    required this.isActive,
    required this.modifiedDate,
  });

  factory Service.fromJson(Map<String, dynamic> json) =>
      _$ServiceFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceToJson(this);
}
