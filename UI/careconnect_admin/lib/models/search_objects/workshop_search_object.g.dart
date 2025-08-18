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
  startDateGTE: json['startDateGTE'] == null
      ? null
      : DateTime.parse(json['startDateGTE'] as String),
  startDateLTE: json['startDateLTE'] == null
      ? null
      : DateTime.parse(json['startDateLTE'] as String),
  endDateGTE: json['endDateGTE'] == null
      ? null
      : DateTime.parse(json['endDateGTE'] as String),
  endDateLTE: json['endDateLTE'] == null
      ? null
      : DateTime.parse(json['endDateLTE'] as String),
  price: (json['price'] as num?)?.toDouble(),
  memberPrice: (json['memberPrice'] as num?)?.toDouble(),
  maxParticipants: (json['maxParticipants'] as num?)?.toInt(),
  participants: (json['participants'] as num?)?.toInt(),
  workshopType: json['workshopType'] as String?,
  additionalData: json['additionalData'] == null
      ? null
      : WorkshopAdditionalData.fromJson(
          json['additionalData'] as Map<String, dynamic>,
        ),
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
  'startDateGTE': instance.startDateGTE?.toIso8601String(),
  'startDateLTE': instance.startDateLTE?.toIso8601String(),
  'endDateGTE': instance.endDateGTE?.toIso8601String(),
  'endDateLTE': instance.endDateLTE?.toIso8601String(),
  'price': instance.price,
  'memberPrice': instance.memberPrice,
  'maxParticipants': instance.maxParticipants,
  'participants': instance.participants,
  'workshopType': instance.workshopType,
  'additionalData': instance.additionalData?.toJson(),
  'page': instance.page,
  'sortBy': instance.sortBy,
  'sortAscending': instance.sortAscending,
  'includeTotalCount': instance.includeTotalCount,
  'retrieveAll': instance.retrieveAll,
};
