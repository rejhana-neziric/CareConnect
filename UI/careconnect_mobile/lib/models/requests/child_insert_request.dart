import 'package:json_annotation/json_annotation.dart';

part 'child_insert_request.g.dart'; // Don't open or edit this

@JsonSerializable()
class ChildInsertRequest {
  String firstName;
  String lastName;
  DateTime birthDate;
  String gender;

  ChildInsertRequest({
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.gender,
  });

  factory ChildInsertRequest.fromJson(Map<String, dynamic> json) =>
      _$ChildInsertRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ChildInsertRequestToJson(this);
}
