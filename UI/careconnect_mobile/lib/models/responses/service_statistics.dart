import 'package:json_annotation/json_annotation.dart';

part 'service_statistics.g.dart';

@JsonSerializable(explicitToJson: true)
class ServiceStatistics {
  final int totalServices;
  final double? averagePrice;
  final double? averageMemberPrice;

  ServiceStatistics({
    required this.totalServices,
    this.averagePrice,
    this.averageMemberPrice,
  });

  factory ServiceStatistics.fromJson(Map<String, dynamic> json) =>
      _$ServiceStatisticsFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceStatisticsToJson(this);
}
