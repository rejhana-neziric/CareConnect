import 'package:careconnect_mobile/models/requests/child_insert_request.dart';
import 'package:careconnect_mobile/models/requests/client_insert_request.dart';
import 'package:json_annotation/json_annotation.dart';

part 'clients_child_insert_request.g.dart'; // Don't open or edit this

@JsonSerializable()
class ClientsChildInsertRequest {
  ClientInsertRequest clientInsertRequest;
  ChildInsertRequest childInsertRequest;

  ClientsChildInsertRequest({
    required this.clientInsertRequest,
    required this.childInsertRequest,
  });

  factory ClientsChildInsertRequest.fromJson(Map<String, dynamic> json) =>
      _$ClientsChildInsertRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ClientsChildInsertRequestToJson(this);
}
