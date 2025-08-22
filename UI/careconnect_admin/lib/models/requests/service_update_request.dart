import 'package:json_annotation/json_annotation.dart';

part 'service_update_request.g.dart'; // Don't open or edit this

@JsonSerializable()
class ServiceUpdateRequest {
  String? name;
  String? description;
  double? price;
  double? memberPrice;
  bool? isActive;
  int? serviceTypeId;

  ServiceUpdateRequest({
    this.name,
    this.description,
    this.price,
    this.memberPrice,
    this.isActive,
    this.serviceTypeId,
  });

  factory ServiceUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$ServiceUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceUpdateRequestToJson(this);
}
