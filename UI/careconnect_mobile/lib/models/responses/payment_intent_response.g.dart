// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_intent_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentIntentResponse _$PaymentIntentResponseFromJson(
  Map<String, dynamic> json,
) => PaymentIntentResponse(
  clientSecret: json['clientSecret'] as String,
  paymentIntentId: json['paymentIntentId'] as String,
  amount: (json['amount'] as num).toDouble(),
  currency: json['currency'] as String,
);

Map<String, dynamic> _$PaymentIntentResponseToJson(
  PaymentIntentResponse instance,
) => <String, dynamic>{
  'clientSecret': instance.clientSecret,
  'paymentIntentId': instance.paymentIntentId,
  'amount': instance.amount,
  'currency': instance.currency,
};
