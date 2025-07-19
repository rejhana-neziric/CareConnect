// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserUpdateRequest _$UserUpdateRequestFromJson(Map<String, dynamic> json) =>
    UserUpdateRequest(
      phoneNumber: json['phoneNumber'] as String?,
      username: json['username'] as String?,
      password: json['password'] as String?,
      confirmationPassword: json['confirmationPassword'] as String?,
      email: json['email'] as String?,
      status: json['status'] as bool?,
      address: json['address'] as String?,
    );

Map<String, dynamic> _$UserUpdateRequestToJson(UserUpdateRequest instance) =>
    <String, dynamic>{
      'phoneNumber': instance.phoneNumber,
      'username': instance.username,
      'password': instance.password,
      'confirmationPassword': instance.confirmationPassword,
      'email': instance.email,
      'status': instance.status,
      'address': instance.address,
    };
