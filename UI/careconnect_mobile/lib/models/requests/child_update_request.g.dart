// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChildUpdateRequest _$ChildUpdateRequestFromJson(Map<String, dynamic> json) =>
    ChildUpdateRequest(
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      birthDate: json['birthDate'] == null
          ? null
          : DateTime.parse(json['birthDate'] as String),
    );

Map<String, dynamic> _$ChildUpdateRequestToJson(ChildUpdateRequest instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'birthDate': instance.birthDate?.toIso8601String(),
    };
