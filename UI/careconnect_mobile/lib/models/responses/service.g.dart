// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Service _$ServiceFromJson(Map<String, dynamic> json) => Service(
  serviceId: (json['serviceId'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String?,
  price: (json['price'] as num?)?.toDouble(),
  memberPrice: (json['memberPrice'] as num?)?.toDouble(),
  isActive: json['isActive'] as bool,
  modifiedDate: DateTime.parse(json['modifiedDate'] as String),
  serviceType: json['serviceType'] == null
      ? null
      : ServiceType.fromJson(json['serviceType'] as Map<String, dynamic>),
  serviceTypeId: (json['serviceTypeId'] as num).toInt(),
);

Map<String, dynamic> _$ServiceToJson(Service instance) => <String, dynamic>{
  'serviceId': instance.serviceId,
  'name': instance.name,
  'description': instance.description,
  'price': instance.price,
  'memberPrice': instance.memberPrice,
  'isActive': instance.isActive,
  'modifiedDate': instance.modifiedDate.toIso8601String(),
  'serviceType': instance.serviceType,
  'serviceTypeId': instance.serviceTypeId,
};
