import 'package:json_annotation/json_annotation.dart';

part 'qualification_update_request.g.dart'; // Don't open or edit this

@JsonSerializable()
class QualificationUpdateRequest {
  final String? name;
  final String? instituteName;
  final DateTime? procurementYear;

  QualificationUpdateRequest({
    this.name,
    this.instituteName,
    this.procurementYear,
  });

  /// Connect the generated [_$UserInsertRequestFromJson] function to the `fromJson`
  /// factory.
  factory QualificationUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$QualificationUpdateRequestFromJson(json);

  /// Connect the generated [_$UserToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$QualificationUpdateRequestToJson(this);
}
