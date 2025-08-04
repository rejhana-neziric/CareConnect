// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_statistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceStatistics _$ServiceStatisticsFromJson(Map<String, dynamic> json) =>
    ServiceStatistics(
      totalServices: (json['totalServices'] as num).toInt(),
      averagePrice: (json['averagePrice'] as num?)?.toDouble(),
      averageMemberPrice: (json['averageMemberPrice'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ServiceStatisticsToJson(ServiceStatistics instance) =>
    <String, dynamic>{
      'totalServices': instance.totalServices,
      'averagePrice': instance.averagePrice,
      'averageMemberPrice': instance.averageMemberPrice,
    };
