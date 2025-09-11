// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_insert_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientInsertRequest _$ClientInsertRequestFromJson(Map<String, dynamic> json) =>
    ClientInsertRequest(
      employmentStatus: json['employmentStatus'] as bool,
      user: UserInsertRequest.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ClientInsertRequestToJson(
  ClientInsertRequest instance,
) => <String, dynamic>{
  'employmentStatus': instance.employmentStatus,
  'user': instance.user,
};
