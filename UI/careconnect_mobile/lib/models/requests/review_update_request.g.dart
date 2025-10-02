// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewUpdateRequest _$ReviewUpdateRequestFromJson(Map<String, dynamic> json) =>
    ReviewUpdateRequest(
      title: json['title'] as String?,
      content: json['content'] as String?,
      stars: (json['stars'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ReviewUpdateRequestToJson(
  ReviewUpdateRequest instance,
) => <String, dynamic>{
  'title': instance.title,
  'content': instance.content,
  'stars': instance.stars,
};
