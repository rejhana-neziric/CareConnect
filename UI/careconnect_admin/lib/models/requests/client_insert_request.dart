import 'package:careconnect_admin/models/requests/user_insert_request.dart';

import 'package:json_annotation/json_annotation.dart';

part 'client_insert_request.g.dart'; // Don't open or edit this

@JsonSerializable()
class ClientInsertRequest {
  final bool employmentStatus;
  final UserInsertRequest user;

  ClientInsertRequest({required this.employmentStatus, required this.user});

  factory ClientInsertRequest.fromJson(Map<String, dynamic> json) =>
      _$ClientInsertRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ClientInsertRequestToJson(this);
}
