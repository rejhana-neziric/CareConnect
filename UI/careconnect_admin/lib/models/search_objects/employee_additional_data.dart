import 'package:json_annotation/json_annotation.dart';

part 'employee_additional_data.g.dart';

@JsonSerializable(explicitToJson: true)
class EmployeeAdditionalData {
  bool? isUserIncluded;
  bool? isQualificationIncluded;
  bool? isEmployeeAvailabilityIncluded;

  EmployeeAdditionalData({
    this.isUserIncluded,
    this.isQualificationIncluded,
    this.isEmployeeAvailabilityIncluded,
  });

  factory EmployeeAdditionalData.fromJson(Map<String, dynamic> json) =>
      _$EmployeeAdditionalDataFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeAdditionalDataToJson(this);
}
