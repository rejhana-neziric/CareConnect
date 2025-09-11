// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clients_child_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientsChildSearchObject _$ClientsChildSearchObjectFromJson(
  Map<String, dynamic> json,
) => ClientsChildSearchObject(
  clientSearchObject: json['clientSearchObject'] == null
      ? null
      : ClientSearchObject.fromJson(
          json['clientSearchObject'] as Map<String, dynamic>,
        ),
  childSearchObject: json['childSearchObject'] == null
      ? null
      : ChildSearchObject.fromJson(
          json['childSearchObject'] as Map<String, dynamic>,
        ),
  fts: json['fts'] as String?,
  page: (json['page'] as num?)?.toInt(),
  sortBy: json['sortBy'] as String?,
  sortAscending: json['sortAscending'] as bool?,
  additionalData: json['additionalData'] == null
      ? null
      : ClientsChildAdditionalData.fromJson(
          json['additionalData'] as Map<String, dynamic>,
        ),
  includeTotalCount: json['includeTotalCount'] as bool?,
);

Map<String, dynamic> _$ClientsChildSearchObjectToJson(
  ClientsChildSearchObject instance,
) => <String, dynamic>{
  'clientSearchObject': instance.clientSearchObject?.toJson(),
  'childSearchObject': instance.childSearchObject?.toJson(),
  'fts': instance.fts,
  'page': instance.page,
  'sortBy': instance.sortBy,
  'sortAscending': instance.sortAscending,
  'additionalData': instance.additionalData?.toJson(),
  'includeTotalCount': instance.includeTotalCount,
};
