import 'package:json_annotation/json_annotation.dart';

part 'review_additional_data.g.dart';

@JsonSerializable(explicitToJson: true)
class ReviewAdditionalData {
  final bool? isUserIncluded;
  final bool? isEmployeeIncluded;

  ReviewAdditionalData({this.isUserIncluded, this.isEmployeeIncluded});

  factory ReviewAdditionalData.fromJson(Map<String, dynamic> json) =>
      _$ReviewAdditionalDataFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewAdditionalDataToJson(this);
}
