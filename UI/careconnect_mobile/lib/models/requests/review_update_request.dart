import 'package:json_annotation/json_annotation.dart';

part 'review_update_request.g.dart';

@JsonSerializable()
class ReviewUpdateRequest {
  String? title;
  String? content;
  int? stars;

  ReviewUpdateRequest({this.title, this.content, this.stars});

  factory ReviewUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$ReviewUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewUpdateRequestToJson(this);
}
