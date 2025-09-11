import 'package:json_annotation/json_annotation.dart';

part 'kpi_data.g.dart';

@JsonSerializable()
class KpiData {
  final int totalNewClients;
  final int totalAppointments;
  final int totalWorkshops;
  final double newClientsChange;
  final double appointmentsChange;
  final double workshopsChange;

  KpiData({
    required this.totalNewClients,
    required this.totalAppointments,
    required this.totalWorkshops,
    required this.newClientsChange,
    required this.appointmentsChange,
    required this.workshopsChange,
  });

  factory KpiData.fromJson(Map<String, dynamic> json) =>
      _$KpiDataFromJson(json);

  Map<String, dynamic> toJson() => _$KpiDataToJson(this);
}
