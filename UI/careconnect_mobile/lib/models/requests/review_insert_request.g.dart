// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_insert_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewInsertRequest _$ReviewInsertRequestFromJson(Map<String, dynamic> json) =>
    ReviewInsertRequest(
      userId: (json['userId'] as num).toInt(),
      title: json['title'] as String,
      content: json['content'] as String,
      employeeId: (json['employeeId'] as num).toInt(),
      stars: (json['stars'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ReviewInsertRequestToJson(
  ReviewInsertRequest instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'title': instance.title,
  'content': instance.content,
  'employeeId': instance.employeeId,
  'stars': instance.stars,
};
