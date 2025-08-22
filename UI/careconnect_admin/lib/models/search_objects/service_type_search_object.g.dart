// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_type_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceTypeSearchObject _$ServiceTypeSearchObjectFromJson(
  Map<String, dynamic> json,
) => ServiceTypeSearchObject(
  fts: json['fts'] as String?,
  page: (json['page'] as num?)?.toInt(),
  sortBy: json['sortBy'] as String?,
  sortAscending: json['sortAscending'] as bool?,
  includeTotalCount: json['includeTotalCount'] as bool?,
  retrieveAll: json['retrieveAll'] as bool?,
);

Map<String, dynamic> _$ServiceTypeSearchObjectToJson(
  ServiceTypeSearchObject instance,
) => <String, dynamic>{
  'fts': instance.fts,
  'page': instance.page,
  'sortBy': instance.sortBy,
  'sortAscending': instance.sortAscending,
  'includeTotalCount': instance.includeTotalCount,
  'retrieveAll': instance.retrieveAll,
};
