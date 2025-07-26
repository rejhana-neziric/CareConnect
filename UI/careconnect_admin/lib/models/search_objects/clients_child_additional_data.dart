import 'package:json_annotation/json_annotation.dart';

part 'clients_child_additional_data.g.dart';

@JsonSerializable(explicitToJson: true)
class ClientsChildAdditionalData {
  bool? isClientIncluded;
  bool? isChildIncluded;

  ClientsChildAdditionalData({this.isClientIncluded, this.isChildIncluded});

  factory ClientsChildAdditionalData.fromJson(Map<String, dynamic> json) =>
      _$ClientsChildAdditionalDataFromJson(json);

  Map<String, dynamic> toJson() => _$ClientsChildAdditionalDataToJson(this);
}
