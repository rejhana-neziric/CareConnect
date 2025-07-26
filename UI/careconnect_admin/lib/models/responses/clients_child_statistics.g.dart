// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clients_child_statistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientsChildStatistics _$ClientsChildStatisticsFromJson(
  Map<String, dynamic> json,
) => ClientsChildStatistics(
  totalParents: (json['totalParents'] as num).toInt(),
  totalChildren: (json['totalChildren'] as num).toInt(),
  employedParents: (json['employedParents'] as num).toInt(),
  newClientsThisMonth: (json['newClientsThisMonth'] as num).toInt(),
  childrenPerAgeGroup: (json['childrenPerAgeGroup'] as List<dynamic>)
      .map((e) => AgeGroup.fromJson(e as Map<String, dynamic>))
      .toList(),
  childrenPerGender: (json['childrenPerGender'] as List<dynamic>)
      .map((e) => GenderGroup.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ClientsChildStatisticsToJson(
  ClientsChildStatistics instance,
) => <String, dynamic>{
  'totalParents': instance.totalParents,
  'totalChildren': instance.totalChildren,
  'employedParents': instance.employedParents,
  'newClientsThisMonth': instance.newClientsThisMonth,
  'childrenPerAgeGroup': instance.childrenPerAgeGroup
      .map((e) => e.toJson())
      .toList(),
  'childrenPerGender': instance.childrenPerGender
      .map((e) => e.toJson())
      .toList(),
};
