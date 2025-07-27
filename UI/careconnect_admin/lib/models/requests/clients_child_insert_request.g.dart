// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clients_child_insert_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientsChildInsertRequest _$ClientsChildInsertRequestFromJson(
  Map<String, dynamic> json,
) => ClientsChildInsertRequest(
  clientInsertRequest: ClientInsertRequest.fromJson(
    json['clientInsertRequest'] as Map<String, dynamic>,
  ),
  childInsertRequest: ChildInsertRequest.fromJson(
    json['childInsertRequest'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$ClientsChildInsertRequestToJson(
  ClientsChildInsertRequest instance,
) => <String, dynamic>{
  'clientInsertRequest': instance.clientInsertRequest,
  'childInsertRequest': instance.childInsertRequest,
};
