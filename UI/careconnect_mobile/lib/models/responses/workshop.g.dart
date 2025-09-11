// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workshop.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Workshop _$WorkshopFromJson(Map<String, dynamic> json) => Workshop(
  workshopId: (json['workshopId'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String,
  status: json['status'] as String,
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: json['endDate'] == null
      ? null
      : DateTime.parse(json['endDate'] as String),
  price: (json['price'] as num?)?.toDouble(),
  memberPrice: (json['memberPrice'] as num?)?.toDouble(),
  maxParticipants: (json['maxParticipants'] as num?)?.toInt(),
  participants: (json['participants'] as num?)?.toInt(),
  notes: json['notes'] as String?,
  modifiedDate: DateTime.parse(json['modifiedDate'] as String),
  workshopType: json['workshopType'] as String,
);

Map<String, dynamic> _$WorkshopToJson(Workshop instance) => <String, dynamic>{
  'workshopId': instance.workshopId,
  'name': instance.name,
  'description': instance.description,
  'status': instance.status,
  'startDate': instance.startDate.toIso8601String(),
  'endDate': instance.endDate?.toIso8601String(),
  'price': instance.price,
  'memberPrice': instance.memberPrice,
  'maxParticipants': instance.maxParticipants,
  'participants': instance.participants,
  'notes': instance.notes,
  'modifiedDate': instance.modifiedDate.toIso8601String(),
  'workshopType': instance.workshopType,
};
