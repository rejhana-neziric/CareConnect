import 'package:json_annotation/json_annotation.dart';

part 'role_insert_request.g.dart';

@JsonSerializable()
class RoleInsertRequest {
  String name;
  String? description;

  RoleInsertRequest({required this.name, this.description});

  factory RoleInsertRequest.fromJson(Map<String, dynamic> json) =>
      _$RoleInsertRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RoleInsertRequestToJson(this);
}
