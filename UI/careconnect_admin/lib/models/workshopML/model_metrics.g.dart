// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_metrics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModelMetrics _$ModelMetricsFromJson(Map<String, dynamic> json) => ModelMetrics(
  rSquared: (json['rSquared'] as num?)?.toDouble(),
  rootMeanSquaredError: (json['rootMeanSquaredError'] as num?)?.toDouble(),
  meanAbsoluteError: (json['meanAbsoluteError'] as num?)?.toDouble(),
);

Map<String, dynamic> _$ModelMetricsToJson(ModelMetrics instance) =>
    <String, dynamic>{
      'rSquared': instance.rSquared,
      'rootMeanSquaredError': instance.rootMeanSquaredError,
      'meanAbsoluteError': instance.meanAbsoluteError,
    };
