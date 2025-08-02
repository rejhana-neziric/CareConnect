// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Service _$ServiceFromJson(Map<String, dynamic> json) => Service(
  name: json['name'] as String,
  description: json['description'] as String?,
  price: (json['price'] as num?)?.toDouble(),
  memberPrice: (json['memberPrice'] as num?)?.toDouble(),
);

Map<String, dynamic> _$ServiceToJson(Service instance) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'price': instance.price,
  'memberPrice': instance.memberPrice,
};
