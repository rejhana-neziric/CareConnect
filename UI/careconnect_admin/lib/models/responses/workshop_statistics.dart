import 'package:json_annotation/json_annotation.dart';

part 'workshop_statistics.g.dart';

@JsonSerializable(explicitToJson: true)
class WorkshopStatistics {
  final int totalWorkshops;
  final int upcoming;
  final int averageParticipants;

  WorkshopStatistics({
    required this.totalWorkshops,
    required this.upcoming,
    required this.averageParticipants,
  });

  factory WorkshopStatistics.fromJson(Map<String, dynamic> json) =>
      _$WorkshopStatisticsFromJson(json);

  Map<String, dynamic> toJson() => _$WorkshopStatisticsToJson(this);
}
