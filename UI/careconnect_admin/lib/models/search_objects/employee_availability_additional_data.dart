import 'package:json_annotation/json_annotation.dart';

part 'employee_availability_additional_data.g.dart';

@JsonSerializable(explicitToJson: true)
class EmployeeAvailabilityAdditionalData {
  bool? isEmployeeIncluded;
  bool? isServiceIncluded;

  EmployeeAvailabilityAdditionalData({
    this.isEmployeeIncluded,
    this.isServiceIncluded,
  });

  factory EmployeeAvailabilityAdditionalData.fromJson(
    Map<String, dynamic> json,
  ) => _$EmployeeAvailabilityAdditionalDataFromJson(json);

  Map<String, dynamic> toJson() =>
      _$EmployeeAvailabilityAdditionalDataToJson(this);
}
