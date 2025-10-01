import 'package:careconnect_mobile/models/requests/appointment_insert_request.dart';

import 'package:json_annotation/json_annotation.dart';

part 'enrollment_request.g.dart';

@JsonSerializable()
class EnrollmentRequest {
  int clientId;
  int? childId;
  int workshopId;
  String? paymentIntentId;

  EnrollmentRequest({
    required this.clientId,
    required this.childId,
    required this.workshopId,
    required this.paymentIntentId,
  });

  factory EnrollmentRequest.fromJson(Map<String, dynamic> json) =>
      _$EnrollmentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$EnrollmentRequestToJson(this);
}
