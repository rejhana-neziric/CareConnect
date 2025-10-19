// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrainingResult _$TrainingResultFromJson(Map<String, dynamic> json) =>
    TrainingResult(
      message: json['message'] as String,
      workshopsUsed: (json['workshopsUsed'] as num).toInt(),
      metrics: json['metrics'] == null
          ? null
          : ModelMetrics.fromJson(json['metrics'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TrainingResultToJson(TrainingResult instance) =>
    <String, dynamic>{
      'message': instance.message,
      'workshopsUsed': instance.workshopsUsed,
      'metrics': instance.metrics,
    };
