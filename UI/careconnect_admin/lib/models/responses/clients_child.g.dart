// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clients_child.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientsChild _$ClientsChildFromJson(Map<String, dynamic> json) => ClientsChild(
  child: Child.fromJson(json['child'] as Map<String, dynamic>),
  client: Client.fromJson(json['client'] as Map<String, dynamic>),
  appointments: (json['appointments'] as List<dynamic>)
      .map((e) => Appointment.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ClientsChildToJson(ClientsChild instance) =>
    <String, dynamic>{
      'child': instance.child.toJson(),
      'client': instance.client.toJson(),
      'appointments': instance.appointments.map((e) => e.toJson()).toList(),
    };
