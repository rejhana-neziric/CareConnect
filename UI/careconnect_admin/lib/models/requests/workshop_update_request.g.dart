// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workshop_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkshopUpdateRequest _$WorkshopUpdateRequestFromJson(
  Map<String, dynamic> json,
) => WorkshopUpdateRequest(
  name: json['name'] as String?,
  description: json['description'] as String?,
  workshopType: json['workshopType'] as String?,
  startDate: json['startDate'] == null
      ? null
      : DateTime.parse(json['startDate'] as String),
  endDate: json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String),
  price: (json['price'] as num?)?.toDouble(),
  memberPrice: (json['memberPrice'] as num?)?.toDouble(),
  maxParticipants: (json['maxParticipants'] as num?)?.toInt(),
  participants: (json['participants'] as num?)?.toInt(),
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$WorkshopUpdateRequestToJson(
  WorkshopUpdateRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'workshopType': instance.workshopType,
  'startDate': instance.startDate?.toIso8601String(),
  'endDate': instance.endDate?.toIso8601String(),
  'price': instance.price,
  'memberPrice': instance.memberPrice,
  'maxParticipants': instance.maxParticipants,
  'participants': instance.participants,
  'notes': instance.notes,
};
