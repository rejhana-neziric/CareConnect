import 'package:json_annotation/json_annotation.dart';

part 'child_additional_data.g.dart';

@JsonSerializable(explicitToJson: true)
class ChildAdditionalData {
  bool? isDiagnosisIncluded;

  ChildAdditionalData({this.isDiagnosisIncluded});

  factory ChildAdditionalData.fromJson(Map<String, dynamic> json) =>
      _$ChildAdditionalDataFromJson(json);

  Map<String, dynamic> toJson() => _$ChildAdditionalDataToJson(this);
}
