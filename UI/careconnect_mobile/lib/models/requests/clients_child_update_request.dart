import 'package:careconnect_mobile/models/requests/client_update_request.dart';
import 'package:json_annotation/json_annotation.dart';

part 'clients_child_update_request.g.dart'; // Don't open or edit this

@JsonSerializable()
class ClientsChildUpdateRequest {
  ClientUpdateRequest clientUpdateRequest;

  ClientsChildUpdateRequest({required this.clientUpdateRequest});

  factory ClientsChildUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$ClientsChildUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ClientsChildUpdateRequestToJson(this);
}
