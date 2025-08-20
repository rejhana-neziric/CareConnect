// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workshop_statistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkshopStatistics _$WorkshopStatisticsFromJson(Map<String, dynamic> json) =>
    WorkshopStatistics(
      totalWorkshops: (json['totalWorkshops'] as num).toInt(),
      upcoming: (json['upcoming'] as num).toInt(),
      averageParticipants: (json['averageParticipants'] as num).toInt(),
    );

Map<String, dynamic> _$WorkshopStatisticsToJson(WorkshopStatistics instance) =>
    <String, dynamic>{
      'totalWorkshops': instance.totalWorkshops,
      'upcoming': instance.upcoming,
      'averageParticipants': instance.averageParticipants,
    };
