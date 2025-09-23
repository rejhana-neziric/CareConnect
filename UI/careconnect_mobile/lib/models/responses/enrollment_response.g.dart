// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enrollment_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EnrollmentResponse _$EnrollmentResponseFromJson(Map<String, dynamic> json) =>
    EnrollmentResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$EnrollmentResponseToJson(EnrollmentResponse instance) =>
    <String, dynamic>{'success': instance.success, 'message': instance.message};
