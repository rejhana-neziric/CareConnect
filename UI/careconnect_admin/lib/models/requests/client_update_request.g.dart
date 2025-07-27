// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientUpdateRequest _$ClientUpdateRequestFromJson(Map<String, dynamic> json) =>
    ClientUpdateRequest(
      employmentStatus: json['employmentStatus'] as bool?,
      user: UserUpdateRequest.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ClientUpdateRequestToJson(
  ClientUpdateRequest instance,
) => <String, dynamic>{
  'employmentStatus': instance.employmentStatus,
  'user': instance.user,
};
