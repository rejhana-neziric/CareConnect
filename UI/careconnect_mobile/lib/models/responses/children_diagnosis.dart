import 'package:careconnect_mobile/models/responses/child.dart';
import 'package:careconnect_mobile/models/responses/diagnosis.dart';
import 'package:json_annotation/json_annotation.dart';

part 'children_diagnosis.g.dart';

@JsonSerializable(explicitToJson: true)
class ChildrenDiagnosis {
  DateTime? diagnosisDate;
  String? notes;
  DateTime modifiedDate;
  Child child;
  Diagnosis diagnosis;

  ChildrenDiagnosis({
    this.diagnosisDate,
    this.notes,
    required this.modifiedDate,
    required this.child,
    required this.diagnosis,
  });

  factory ChildrenDiagnosis.fromJson(Map<String, dynamic> json) =>
      _$ChildrenDiagnosisFromJson(json);

  Map<String, dynamic> toJson() => _$ChildrenDiagnosisToJson(this);
}
