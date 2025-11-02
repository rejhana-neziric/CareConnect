import 'package:careconnect_admin/models/responses/service_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'service.g.dart'; // Don't open or edit this

@JsonSerializable()
class Service {
  final int serviceId;
  final String name;
  final String? description;
  final double? price;
  final bool isActive;
  final DateTime modifiedDate;
  ServiceType? serviceType;
  int serviceTypeId;

  Service({
    required this.serviceId,
    required this.name,
    this.description,
    this.price,
    required this.isActive,
    required this.modifiedDate,
    this.serviceType,
    required this.serviceTypeId,
  });

  factory Service.fromJson(Map<String, dynamic> json) =>
      _$ServiceFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceToJson(this);
}
