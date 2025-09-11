// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'age_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgeGroup _$AgeGroupFromJson(Map<String, dynamic> json) => AgeGroup(
  category: json['category'] as String,
  number: (json['number'] as num).toInt(),
);

Map<String, dynamic> _$AgeGroupToJson(AgeGroup instance) => <String, dynamic>{
  'category': instance.category,
  'number': instance.number,
};
