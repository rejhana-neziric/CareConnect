import 'package:json_annotation/json_annotation.dart';

part 'child_update_request.g.dart';

@JsonSerializable()
class ChildUpdateRequest {
  String? firstName;
  String? lastName;
  DateTime? birthDate;

  ChildUpdateRequest({
    required this.firstName,
    required this.lastName,
    required this.birthDate,
  });

  factory ChildUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$ChildUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ChildUpdateRequestToJson(this);
}
