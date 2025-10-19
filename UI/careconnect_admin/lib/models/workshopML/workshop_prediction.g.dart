// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workshop_prediction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkshopPrediction _$WorkshopPredictionFromJson(Map<String, dynamic> json) =>
    WorkshopPrediction(
      workshopId: (json['workshopId'] as num).toInt(),
      workshopName: json['workshopName'] as String,
      predictedParticipants: (json['predictedParticipants'] as num).toDouble(),
      maxParticipants: (json['maxParticipants'] as num?)?.toInt(),
      utilizationPercentage: (json['utilizationPercentage'] as num?)
          ?.toDouble(),
      recommendation: json['recommendation'] as String?,
    );

Map<String, dynamic> _$WorkshopPredictionToJson(WorkshopPrediction instance) =>
    <String, dynamic>{
      'workshopId': instance.workshopId,
      'workshopName': instance.workshopName,
      'predictedParticipants': instance.predictedParticipants,
      'maxParticipants': instance.maxParticipants,
      'utilizationPercentage': instance.utilizationPercentage,
      'recommendation': instance.recommendation,
    };
