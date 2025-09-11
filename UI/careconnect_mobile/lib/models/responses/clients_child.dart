import 'package:careconnect_mobile/models/responses/child.dart';
import 'package:careconnect_mobile/models/responses/client.dart';

import 'package:json_annotation/json_annotation.dart';

part 'clients_child.g.dart';

@JsonSerializable(explicitToJson: true)
class ClientsChild {
  final Child child;
  final Client client;
  // final List<Appointment> appointments;

  ClientsChild({
    required this.child,
    required this.client,
    // required this.appointments,
  });

  factory ClientsChild.fromJson(Map<String, dynamic> json) =>
      _$ClientsChildFromJson(json);

  Map<String, dynamic> toJson() => _$ClientsChildToJson(this);
}
