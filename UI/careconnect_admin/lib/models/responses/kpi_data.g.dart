// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kpi_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KpiData _$KpiDataFromJson(Map<String, dynamic> json) => KpiData(
  totalNewClients: (json['totalNewClients'] as num).toInt(),
  totalAppointments: (json['totalAppointments'] as num).toInt(),
  totalWorkshops: (json['totalWorkshops'] as num).toInt(),
  newClientsChange: (json['newClientsChange'] as num).toDouble(),
  appointmentsChange: (json['appointmentsChange'] as num).toDouble(),
  workshopsChange: (json['workshopsChange'] as num).toDouble(),
);

Map<String, dynamic> _$KpiDataToJson(KpiData instance) => <String, dynamic>{
  'totalNewClients': instance.totalNewClients,
  'totalAppointments': instance.totalAppointments,
  'totalWorkshops': instance.totalWorkshops,
  'newClientsChange': instance.newClientsChange,
  'appointmentsChange': instance.appointmentsChange,
  'workshopsChange': instance.workshopsChange,
};
