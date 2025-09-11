// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'children_diagnosis_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChildrenDiagnosisSearchObject _$ChildrenDiagnosisSearchObjectFromJson(
  Map<String, dynamic> json,
) => ChildrenDiagnosisSearchObject(
  fts: json['fts'] as String?,
  diagnosisDateGTE: json['diagnosisDateGTE'] == null
      ? null
      : DateTime.parse(json['diagnosisDateGTE'] as String),
  diagnosisDateLTE: json['diagnosisDateLTE'] == null
      ? null
      : DateTime.parse(json['diagnosisDateLTE'] as String),
  childFirstNameGTE: json['childFirstNameGTE'] as String?,
  childLastNameGTE: json['childLastNameGTE'] as String?,
  diagnosisNameGTE: json['diagnosisNameGTE'] as String?,
  page: (json['page'] as num?)?.toInt(),
  sortBy: json['sortBy'] as String?,
  sortAscending: json['sortAscending'] as bool?,
  additionalData: json['additionalData'] == null
      ? null
      : ChildrenDiagnosisAdditionalData.fromJson(
          json['additionalData'] as Map<String, dynamic>,
        ),
  includeTotalCount: json['includeTotalCount'] as bool?,
);

Map<String, dynamic> _$ChildrenDiagnosisSearchObjectToJson(
  ChildrenDiagnosisSearchObject instance,
) => <String, dynamic>{
  'fts': instance.fts,
  'diagnosisDateGTE': instance.diagnosisDateGTE?.toIso8601String(),
  'diagnosisDateLTE': instance.diagnosisDateLTE?.toIso8601String(),
  'childFirstNameGTE': instance.childFirstNameGTE,
  'childLastNameGTE': instance.childLastNameGTE,
  'diagnosisNameGTE': instance.diagnosisNameGTE,
  'page': instance.page,
  'sortBy': instance.sortBy,
  'sortAscending': instance.sortAscending,
  'additionalData': instance.additionalData?.toJson(),
  'includeTotalCount': instance.includeTotalCount,
};
