// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enrollment_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EnrollmentRequest _$EnrollmentRequestFromJson(Map<String, dynamic> json) =>
    EnrollmentRequest(
      clientId: (json['clientId'] as num).toInt(),
      childId: (json['childId'] as num?)?.toInt(),
      workshopId: (json['workshopId'] as num).toInt(),
      paymentIntentId: json['paymentIntentId'] as String?,
    );

Map<String, dynamic> _$EnrollmentRequestToJson(EnrollmentRequest instance) =>
    <String, dynamic>{
      'clientId': instance.clientId,
      'childId': instance.childId,
      'workshopId': instance.workshopId,
      'paymentIntentId': instance.paymentIntentId,
    };
