import 'package:json_annotation/json_annotation.dart';

part 'enrollment_response.g.dart';

@JsonSerializable(explicitToJson: true)
class EnrollmentResponse {
  final bool success;
  final String message;

  EnrollmentResponse({required this.success, required this.message});

  factory EnrollmentResponse.fromJson(Map<String, dynamic> json) =>
      _$EnrollmentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EnrollmentResponseToJson(this);
}
