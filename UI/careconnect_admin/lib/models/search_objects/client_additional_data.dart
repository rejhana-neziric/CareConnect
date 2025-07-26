import 'package:json_annotation/json_annotation.dart';

part 'client_additional_data.g.dart';

@JsonSerializable(explicitToJson: true)
class ClientAdditionalData {
  bool? isUserIncluded;
  bool? isChildrenIncluded;

  ClientAdditionalData({this.isUserIncluded, this.isChildrenIncluded});

  factory ClientAdditionalData.fromJson(Map<String, dynamic> json) =>
      _$ClientAdditionalDataFromJson(json);

  Map<String, dynamic> toJson() => _$ClientAdditionalDataToJson(this);
}
