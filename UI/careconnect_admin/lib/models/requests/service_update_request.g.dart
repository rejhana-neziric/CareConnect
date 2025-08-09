// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceUpdateRequest _$ServiceUpdateRequestFromJson(
  Map<String, dynamic> json,
) => ServiceUpdateRequest(
  name: json['name'] as String?,
  description: json['description'] as String?,
  price: (json['price'] as num?)?.toDouble(),
  memberPrice: (json['memberPrice'] as num?)?.toDouble(),
  isActive: json['isActive'] as bool?,
);

Map<String, dynamic> _$ServiceUpdateRequestToJson(
  ServiceUpdateRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'price': instance.price,
  'memberPrice': instance.memberPrice,
  'isActive': instance.isActive,
};
