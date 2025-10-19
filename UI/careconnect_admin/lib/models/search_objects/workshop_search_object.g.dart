// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workshop_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkshopSearchObject _$WorkshopSearchObjectFromJson(
  Map<String, dynamic> json,
) => WorkshopSearchObject(
  fts: json['fts'] as String?,
  nameGTE: json['nameGTE'] as String?,
  status: json['status'] as String?,
  dateGTE: json['dateGTE'] == null
      ? null
      : DateTime.parse(json['dateGTE'] as String),
  dateLTE: json['dateLTE'] == null
      ? null
      : DateTime.parse(json['dateLTE'] as String),
  price: (json['price'] as num?)?.toDouble(),
  maxParticipants: (json['maxParticipants'] as num?)?.toInt(),
  participants: (json['participants'] as num?)?.toInt(),
  workshopType: json['workshopType'] as String?,
  page: (json['page'] as num?)?.toInt(),
  sortBy: json['sortBy'] as String?,
  sortAscending: json['sortAscending'] as bool?,
  includeTotalCount: json['includeTotalCount'] as bool?,
  retrieveAll: json['retrieveAll'] as bool?,
);

Map<String, dynamic> _$WorkshopSearchObjectToJson(
  WorkshopSearchObject instance,
) => <String, dynamic>{
  'fts': instance.fts,
  'nameGTE': instance.nameGTE,
  'status': instance.status,
  'dateGTE': instance.dateGTE?.toIso8601String(),
  'dateLTE': instance.dateLTE?.toIso8601String(),
  'price': instance.price,
  'maxParticipants': instance.maxParticipants,
  'participants': instance.participants,
  'workshopType': instance.workshopType,
  'page': instance.page,
  'sortBy': instance.sortBy,
  'sortAscending': instance.sortAscending,
  'includeTotalCount': instance.includeTotalCount,
  'retrieveAll': instance.retrieveAll,
};
