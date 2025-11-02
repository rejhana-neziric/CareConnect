// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workshop_insert_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkshopInsertRequest _$WorkshopInsertRequestFromJson(
  Map<String, dynamic> json,
) => WorkshopInsertRequest(
  name: json['name'] as String,
  description: json['description'] as String,
  workshopType: json['workshopType'] as String,
  date: DateTime.parse(json['date'] as String),
  price: (json['price'] as num?)?.toDouble(),
  maxParticipants: (json['maxParticipants'] as num?)?.toInt(),
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$WorkshopInsertRequestToJson(
  WorkshopInsertRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'workshopType': instance.workshopType,
  'date': instance.date.toIso8601String(),
  'price': instance.price,
  'maxParticipants': instance.maxParticipants,
  'notes': instance.notes,
};
