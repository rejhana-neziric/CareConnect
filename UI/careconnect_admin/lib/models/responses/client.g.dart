// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Client _$ClientFromJson(Map<String, dynamic> json) => Client(
  employmentStatus: json['employmentStatus'] as bool,
  user: json['user'] == null
      ? null
      : User.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ClientToJson(Client instance) => <String, dynamic>{
  'employmentStatus': instance.employmentStatus,
  'user': instance.user?.toJson(),
};
