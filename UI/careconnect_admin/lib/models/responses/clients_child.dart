import 'package:careconnect_admin/models/responses/child.dart';
import 'package:careconnect_admin/models/responses/client.dart';

import 'package:json_annotation/json_annotation.dart';

part 'clients_child.g.dart';

@JsonSerializable(explicitToJson: true)
class ClientsChild {
  final Child child;
  final Client client;

  ClientsChild({required this.child, required this.client});

  factory ClientsChild.fromJson(Map<String, dynamic> json) =>
      _$ClientsChildFromJson(json);

  Map<String, dynamic> toJson() => _$ClientsChildToJson(this);
}
