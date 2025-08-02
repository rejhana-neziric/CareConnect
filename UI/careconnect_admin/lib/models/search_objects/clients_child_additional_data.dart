import 'package:json_annotation/json_annotation.dart';

part 'clients_child_additional_data.g.dart';

@JsonSerializable(explicitToJson: true)
class ClientsChildAdditionalData {
  bool? isClientIncluded;
  bool? isChildIncluded;
  bool? isAppoinmentIncluded;

  ClientsChildAdditionalData({
    this.isClientIncluded,
    this.isChildIncluded,
    this.isAppoinmentIncluded,
  });

  factory ClientsChildAdditionalData.fromJson(Map<String, dynamic> json) =>
      _$ClientsChildAdditionalDataFromJson(json);

  Map<String, dynamic> toJson() => _$ClientsChildAdditionalDataToJson(this);
}
