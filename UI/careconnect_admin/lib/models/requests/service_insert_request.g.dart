// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_insert_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceInsertRequest _$ServiceInsertRequestFromJson(
  Map<String, dynamic> json,
) => ServiceInsertRequest(
  name: json['name'] as String,
  description: json['description'] as String?,
  price: (json['price'] as num?)?.toDouble(),
  isActive: json['isActive'] as bool,
  serviceTypeId: (json['serviceTypeId'] as num).toInt(),
);

Map<String, dynamic> _$ServiceInsertRequestToJson(
  ServiceInsertRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'price': instance.price,
  'isActive': instance.isActive,
  'serviceTypeId': instance.serviceTypeId,
};
