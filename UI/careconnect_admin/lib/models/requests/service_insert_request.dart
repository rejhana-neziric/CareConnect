import 'package:json_annotation/json_annotation.dart';

part 'service_insert_request.g.dart'; // Don't open or edit this

@JsonSerializable()
class ServiceInsertRequest {
  String name;
  String? description;
  double? price;
  bool isActive;
  int serviceTypeId;

  ServiceInsertRequest({
    required this.name,
    this.description,
    this.price,
    required this.isActive,
    required this.serviceTypeId,
  });

  factory ServiceInsertRequest.fromJson(Map<String, dynamic> json) =>
      _$ServiceInsertRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceInsertRequestToJson(this);
}
