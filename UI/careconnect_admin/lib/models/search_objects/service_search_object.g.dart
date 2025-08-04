// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceSearchObject _$ServiceSearchObjectFromJson(Map<String, dynamic> json) =>
    ServiceSearchObject(
      fts: json['fts'] as String?,
      nameGTE: json['nameGTE'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      memberPrice: (json['memberPrice'] as num?)?.toDouble(),
      page: (json['page'] as num?)?.toInt(),
      sortBy: json['sortBy'] as String?,
      sortAscending: json['sortAscending'] as bool?,
      includeTotalCount: json['includeTotalCount'] as bool?,
      retrieveAll: json['retrieveAll'] as bool?,
    );

Map<String, dynamic> _$ServiceSearchObjectToJson(
  ServiceSearchObject instance,
) => <String, dynamic>{
  'fts': instance.fts,
  'nameGTE': instance.nameGTE,
  'price': instance.price,
  'memberPrice': instance.memberPrice,
  'page': instance.page,
  'sortBy': instance.sortBy,
  'sortAscending': instance.sortAscending,
  'includeTotalCount': instance.includeTotalCount,
  'retrieveAll': instance.retrieveAll,
};
