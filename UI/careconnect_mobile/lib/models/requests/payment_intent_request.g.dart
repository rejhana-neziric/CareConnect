// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_intent_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentIntentRequest _$PaymentIntentRequestFromJson(
  Map<String, dynamic> json,
) => PaymentIntentRequest(
  clientId: (json['clientId'] as num).toInt(),
  childId: (json['childId'] as num?)?.toInt(),
  itemId: (json['itemId'] as num?)?.toInt(),
  itemType: json['itemType'] as String,
  appointment: json['appointment'] == null
      ? null
      : AppointmentInsertRequest.fromJson(
          json['appointment'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$PaymentIntentRequestToJson(
  PaymentIntentRequest instance,
) => <String, dynamic>{
  'clientId': instance.clientId,
  'childId': instance.childId,
  'itemId': instance.itemId,
  'itemType': instance.itemType,
  'appointment': instance.appointment,
};
