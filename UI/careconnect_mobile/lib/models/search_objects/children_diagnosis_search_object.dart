import 'package:careconnect_mobile/models/search_objects/children_diagnosis_additional_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'children_diagnosis_search_object.g.dart';

@JsonSerializable(explicitToJson: true)
class ChildrenDiagnosisSearchObject {
  String? fts;
  DateTime? diagnosisDateGTE;
  DateTime? diagnosisDateLTE;
  String? childFirstNameGTE;
  String? childLastNameGTE;
  String? diagnosisNameGTE;
  int? page;
  String? sortBy;
  bool? sortAscending;
  ChildrenDiagnosisAdditionalData? additionalData;
  bool? includeTotalCount;

  ChildrenDiagnosisSearchObject({
    this.fts,
    this.diagnosisDateGTE,
    this.diagnosisDateLTE,
    this.childFirstNameGTE,
    this.childLastNameGTE,
    this.diagnosisNameGTE,
    this.page,
    this.sortBy,
    this.sortAscending,
    this.additionalData,
    this.includeTotalCount,
  });

  factory ChildrenDiagnosisSearchObject.fromJson(Map<String, dynamic> json) =>
      _$ChildrenDiagnosisSearchObjectFromJson(json);

  Map<String, dynamic> toJson() => _$ChildrenDiagnosisSearchObjectToJson(this);
}
