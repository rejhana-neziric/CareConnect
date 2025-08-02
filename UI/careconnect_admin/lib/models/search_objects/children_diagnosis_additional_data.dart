import 'package:json_annotation/json_annotation.dart';

part 'children_diagnosis_additional_data.g.dart';

@JsonSerializable(explicitToJson: true)
class ChildrenDiagnosisAdditionalData {
  bool? isDiagnosisIncluded;
  bool? isChildIncluded;

  ChildrenDiagnosisAdditionalData({
    this.isDiagnosisIncluded,
    this.isChildIncluded,
  });

  factory ChildrenDiagnosisAdditionalData.fromJson(Map<String, dynamic> json) =>
      _$ChildrenDiagnosisAdditionalDataFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ChildrenDiagnosisAdditionalDataToJson(this);
}
