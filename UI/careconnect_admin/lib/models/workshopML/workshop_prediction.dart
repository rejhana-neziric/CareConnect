import 'package:json_annotation/json_annotation.dart';

part 'workshop_prediction.g.dart';

@JsonSerializable()
class WorkshopPrediction {
  final int workshopId;
  final String workshopName;
  final double predictedParticipants;
  final int? maxParticipants;
  final double? utilizationPercentage;
  final String? recommendation;

  WorkshopPrediction({
    required this.workshopId,
    required this.workshopName,
    required this.predictedParticipants,
    this.maxParticipants,
    this.utilizationPercentage,
    this.recommendation,
  });

  factory WorkshopPrediction.fromJson(Map<String, dynamic> json) =>
      _$WorkshopPredictionFromJson(json);

  Map<String, dynamic> toJson() => _$WorkshopPredictionToJson(this);
}
