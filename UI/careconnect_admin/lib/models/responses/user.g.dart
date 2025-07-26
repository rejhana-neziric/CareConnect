// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  userId: (json['userId'] as num).toInt(),
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  email: json['email'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
  username: json['username'] as String,
  birthDate: json['birthDate'] == null
      ? null
      : DateTime.parse(json['birthDate'] as String),
  gender: json['gender'] as String,
  address: json['address'] as String?,
  status: json['status'] as bool,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'userId': instance.userId,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'email': instance.email,
  'phoneNumber': instance.phoneNumber,
  'username': instance.username,
  'birthDate': instance.birthDate?.toIso8601String(),
  'gender': instance.gender,
  'address': instance.address,
  'status': instance.status,
};
