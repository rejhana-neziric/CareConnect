import 'package:json_annotation/json_annotation.dart';

part 'review_insert_request.g.dart';

@JsonSerializable()
class ReviewInsertRequest {
  int userId;
  String title;
  String content;
  int employeeId;
  int? stars;

  ReviewInsertRequest({
    required this.userId,
    required this.title,
    required this.content,
    required this.employeeId,
    this.stars,
  });

  factory ReviewInsertRequest.fromJson(Map<String, dynamic> json) =>
      _$ReviewInsertRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewInsertRequestToJson(this);
}
