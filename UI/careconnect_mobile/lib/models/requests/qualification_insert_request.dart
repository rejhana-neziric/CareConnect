import 'package:json_annotation/json_annotation.dart';

part 'qualification_insert_request.g.dart'; // Don't open or edit this

@JsonSerializable()
class QualificationInsertRequest {
  final String name;
  final String instituteName;
  final DateTime procurementYear;

  QualificationInsertRequest({
    required this.name,
    required this.instituteName,
    required this.procurementYear,
  });

  /// Connect the generated [_$UserInsertRequestFromJson] function to the `fromJson`
  /// factory.
  factory QualificationInsertRequest.fromJson(Map<String, dynamic> json) =>
      _$QualificationInsertRequestFromJson(json);

  /// Connect the generated [_$UserToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$QualificationInsertRequestToJson(this);
}
