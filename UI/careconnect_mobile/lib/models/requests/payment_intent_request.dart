import 'package:careconnect_mobile/models/requests/appointment_insert_request.dart';

import 'package:json_annotation/json_annotation.dart';

part 'payment_intent_request.g.dart';

@JsonSerializable()
class PaymentIntentRequest {
  int clientId;
  int? childId;
  int? itemId;
  String itemType;
  AppointmentInsertRequest? appointment;

  PaymentIntentRequest({
    required this.clientId,
    required this.childId,
    this.itemId,
    required this.itemType,
    this.appointment,
  });

  factory PaymentIntentRequest.fromJson(Map<String, dynamic> json) =>
      _$PaymentIntentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentIntentRequestToJson(this);
}
