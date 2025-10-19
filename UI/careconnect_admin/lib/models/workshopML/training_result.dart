import 'package:careconnect_admin/models/workshopML/model_metrics.dart';
import 'package:json_annotation/json_annotation.dart';

part 'training_result.g.dart';

@JsonSerializable()
class TrainingResult {
  final String message;
  final int workshopsUsed;
  final ModelMetrics? metrics;

  TrainingResult({
    required this.message,
    required this.workshopsUsed,
    this.metrics,
  });

  factory TrainingResult.fromJson(Map<String, dynamic> json) =>
      _$TrainingResultFromJson(json);

  Map<String, dynamic> toJson() => _$TrainingResultToJson(this);
}
