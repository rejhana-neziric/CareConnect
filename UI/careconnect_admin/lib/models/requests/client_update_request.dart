import 'package:careconnect_admin/models/requests/user_update_request.dart';

import 'package:json_annotation/json_annotation.dart';

part 'client_update_request.g.dart'; // Don't open or edit this

@JsonSerializable()
class ClientUpdateRequest {
  final bool? employmentStatus;
  final UserUpdateRequest user;

  ClientUpdateRequest({required this.employmentStatus, required this.user});

  factory ClientUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$ClientUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ClientUpdateRequestToJson(this);
}
