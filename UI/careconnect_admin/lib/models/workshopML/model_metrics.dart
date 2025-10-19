import 'package:json_annotation/json_annotation.dart';

part 'model_metrics.g.dart';

@JsonSerializable()
class ModelMetrics {
  final double? rSquared;
  final double? rootMeanSquaredError;
  final double? meanAbsoluteError;

  ModelMetrics({
    this.rSquared,
    this.rootMeanSquaredError,
    this.meanAbsoluteError,
  });

  factory ModelMetrics.fromJson(Map<String, dynamic> json) =>
      _$ModelMetricsFromJson(json);

  Map<String, dynamic> toJson() => _$ModelMetricsToJson(this);
}
