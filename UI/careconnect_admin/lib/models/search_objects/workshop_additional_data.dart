import 'package:json_annotation/json_annotation.dart';

part 'workshop_additional_data.g.dart';

@JsonSerializable(explicitToJson: true)
class WorkshopAdditionalData {
  bool? isWorkshopTypeIncluded;

  WorkshopAdditionalData({this.isWorkshopTypeIncluded});

  factory WorkshopAdditionalData.fromJson(Map<String, dynamic> json) =>
      _$WorkshopAdditionalDataFromJson(json);

  Map<String, dynamic> toJson() => _$WorkshopAdditionalDataToJson(this);
}
