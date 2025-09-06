import 'package:careconnect_admin/models/responses/employee.dart';
import 'package:careconnect_admin/models/responses/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'review.g.dart';

@JsonSerializable()
class Review {
  final int reviewId;
  final String title;
  bool isHidden;
  final String content;
  final DateTime publishDate;
  final int? stars;
  final DateTime modifiedDate;
  final Employee? employee;
  final User user;

  Review({
    required this.reviewId,
    required this.title,
    required this.isHidden,
    required this.content,
    required this.publishDate,
    this.stars,
    required this.modifiedDate,
    this.employee,
    required this.user,
  });

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewToJson(this);
}
