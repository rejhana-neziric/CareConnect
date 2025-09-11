import 'package:json_annotation/json_annotation.dart';

part 'report_data.g.dart';

@JsonSerializable()
class ReportData {
  final DateTime date;
  final int newClients;
  final int appointments;
  final int workshops;

  ReportData({
    required this.date,
    required this.newClients,
    required this.appointments,
    required this.workshops,
  });

  factory ReportData.fromJson(Map<String, dynamic> json) =>
      _$ReportDataFromJson(json);

  Map<String, dynamic> toJson() => _$ReportDataToJson(this);
}
