// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) => Notification(
  title: json['title'] as String,
  body: json['body'] as String,
  type: json['type'] as String,
  data: json['data'] as Map<String, dynamic>,
);

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'title': instance.title,
      'body': instance.body,
      'type': instance.type,
      'data': instance.data,
    };
