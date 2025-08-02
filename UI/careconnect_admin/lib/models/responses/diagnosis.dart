import 'package:json_annotation/json_annotation.dart';

part 'diagnosis.g.dart';

@JsonSerializable(explicitToJson: true)
class Diagnosis {
  final String name;
  final String? description;

  Diagnosis({required this.name, this.description});

  factory Diagnosis.fromJson(Map<String, dynamic> json) =>
      _$DiagnosisFromJson(json);

  Map<String, dynamic> toJson() => _$DiagnosisToJson(this);
}
