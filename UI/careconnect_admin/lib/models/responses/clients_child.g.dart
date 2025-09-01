// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clients_child.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientsChild _$ClientsChildFromJson(Map<String, dynamic> json) => ClientsChild(
  child: Child.fromJson(json['child'] as Map<String, dynamic>),
  client: Client.fromJson(json['client'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ClientsChildToJson(ClientsChild instance) =>
    <String, dynamic>{
      'child': instance.child.toJson(),
      'client': instance.client.toJson(),
    };
