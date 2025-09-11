import 'package:json_annotation/json_annotation.dart';

part 'service_type_update_request.g.dart';

@JsonSerializable()
class ServiceTypeUpdateRequest {
  String? name;
  String? description;

  ServiceTypeUpdateRequest({this.name, this.description});

  factory ServiceTypeUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$ServiceTypeUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceTypeUpdateRequestToJson(this);
}
