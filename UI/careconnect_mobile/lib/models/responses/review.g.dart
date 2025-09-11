// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Review _$ReviewFromJson(Map<String, dynamic> json) => Review(
  reviewId: (json['reviewId'] as num).toInt(),
  title: json['title'] as String,
  isHidden: json['isHidden'] as bool,
  content: json['content'] as String,
  publishDate: DateTime.parse(json['publishDate'] as String),
  stars: (json['stars'] as num?)?.toInt(),
  modifiedDate: DateTime.parse(json['modifiedDate'] as String),
  employee: json['employee'] == null
      ? null
      : Employee.fromJson(json['employee'] as Map<String, dynamic>),
  user: User.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
  'reviewId': instance.reviewId,
  'title': instance.title,
  'isHidden': instance.isHidden,
  'content': instance.content,
  'publishDate': instance.publishDate.toIso8601String(),
  'stars': instance.stars,
  'modifiedDate': instance.modifiedDate.toIso8601String(),
  'employee': instance.employee,
  'user': instance.user,
};
