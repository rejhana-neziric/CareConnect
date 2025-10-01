import 'package:json_annotation/json_annotation.dart';

part 'payment_intent_response.g.dart';

@JsonSerializable()
class PaymentIntentResponse {
  String clientSecret;
  String paymentIntentId;
  double amount;
  String currency;

  PaymentIntentResponse({
    required this.clientSecret,
    required this.paymentIntentId,
    required this.amount,
    required this.currency,
  });

  factory PaymentIntentResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentIntentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentIntentResponseToJson(this);
}
