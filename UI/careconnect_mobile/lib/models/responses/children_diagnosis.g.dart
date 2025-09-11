// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'children_diagnosis.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChildrenDiagnosis _$ChildrenDiagnosisFromJson(Map<String, dynamic> json) =>
    ChildrenDiagnosis(
      diagnosisDate: json['diagnosisDate'] == null
          ? null
          : DateTime.parse(json['diagnosisDate'] as String),
      notes: json['notes'] as String?,
      modifiedDate: DateTime.parse(json['modifiedDate'] as String),
      child: Child.fromJson(json['child'] as Map<String, dynamic>),
      diagnosis: Diagnosis.fromJson(json['diagnosis'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChildrenDiagnosisToJson(ChildrenDiagnosis instance) =>
    <String, dynamic>{
      'diagnosisDate': instance.diagnosisDate?.toIso8601String(),
      'notes': instance.notes,
      'modifiedDate': instance.modifiedDate.toIso8601String(),
      'child': instance.child.toJson(),
      'diagnosis': instance.diagnosis.toJson(),
    };
