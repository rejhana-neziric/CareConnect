import 'package:json_annotation/json_annotation.dart';

part 'service_type_insert_request.g.dart';

@JsonSerializable()
class ServiceTypeInsertRequest {
  String name;
  String? description;

  ServiceTypeInsertRequest({required this.name, this.description});

  factory ServiceTypeInsertRequest.fromJson(Map<String, dynamic> json) =>
      _$ServiceTypeInsertRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceTypeInsertRequestToJson(this);
}
