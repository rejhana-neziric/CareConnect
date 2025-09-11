// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gender_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenderGroup _$GenderGroupFromJson(Map<String, dynamic> json) => GenderGroup(
  gender: json['gender'] as String,
  number: (json['number'] as num).toInt(),
);

Map<String, dynamic> _$GenderGroupToJson(GenderGroup instance) =>
    <String, dynamic>{'gender': instance.gender, 'number': instance.number};
