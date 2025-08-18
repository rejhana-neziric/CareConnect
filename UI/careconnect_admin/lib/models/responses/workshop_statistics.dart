import 'package:json_annotation/json_annotation.dart';

part 'workshop_statistics.g.dart';

@JsonSerializable(explicitToJson: true)
class WorkshopStatistics {
  final int totalWorkshops;
  final int upcoming;
  final int averageParticipants;
  final double averageRating;

  WorkshopStatistics({
    required this.totalWorkshops,
    required this.upcoming,
    required this.averageParticipants,
    required this.averageRating,
  });

  factory WorkshopStatistics.fromJson(Map<String, dynamic> json) =>
      _$WorkshopStatisticsFromJson(json);

  Map<String, dynamic> toJson() => _$WorkshopStatisticsToJson(this);
}
