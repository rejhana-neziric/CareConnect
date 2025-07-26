// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChildSearchObject _$ChildSearchObjectFromJson(Map<String, dynamic> json) =>
    ChildSearchObject(
      fts: json['fts'] as String?,
      firstNameGTE: json['firstNameGTE'] as String?,
      lastNameGTE: json['lastNameGTE'] as String?,
      birthDateGTE: json['birthDateGTE'] == null
          ? null
          : DateTime.parse(json['birthDateGTE'] as String),
      birthDateLTE: json['birthDateLTE'] == null
          ? null
          : DateTime.parse(json['birthDateLTE'] as String),
      gender: json['gender'] as String?,
      page: (json['page'] as num?)?.toInt(),
      sortBy: json['sortBy'] as String?,
      sortAscending: json['sortAscending'] as bool?,
      additionalData: json['additionalData'] == null
          ? null
          : ClientAdditionalData.fromJson(
              json['additionalData'] as Map<String, dynamic>,
            ),
      includeTotalCount: json['includeTotalCount'] as bool?,
    );

Map<String, dynamic> _$ChildSearchObjectToJson(ChildSearchObject instance) =>
    <String, dynamic>{
      'fts': instance.fts,
      'firstNameGTE': instance.firstNameGTE,
      'lastNameGTE': instance.lastNameGTE,
      'birthDateGTE': instance.birthDateGTE?.toIso8601String(),
      'birthDateLTE': instance.birthDateLTE?.toIso8601String(),
      'gender': instance.gender,
      'page': instance.page,
      'sortBy': instance.sortBy,
      'sortAscending': instance.sortAscending,
      'additionalData': instance.additionalData?.toJson(),
      'includeTotalCount': instance.includeTotalCount,
    };
