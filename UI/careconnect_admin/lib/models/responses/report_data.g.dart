// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportData _$ReportDataFromJson(Map<String, dynamic> json) => ReportData(
  date: DateTime.parse(json['date'] as String),
  newClients: (json['newClients'] as num).toInt(),
  appointments: (json['appointments'] as num).toInt(),
  workshops: (json['workshops'] as num).toInt(),
);

Map<String, dynamic> _$ReportDataToJson(ReportData instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'newClients': instance.newClients,
      'appointments': instance.appointments,
      'workshops': instance.workshops,
    };
