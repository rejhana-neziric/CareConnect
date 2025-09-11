import 'package:careconnect_mobile/models/search_objects/client_additional_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'client_search_object.g.dart';

@JsonSerializable(explicitToJson: true)
class ClientSearchObject {
  String? fts;
  String? firstNameGTE;
  String? lastNameGTE;
  String? email;
  bool? employmentStatus;
  int? page;
  String? sortBy;
  bool? sortAscending;
  ClientAdditionalData? additionalData;
  bool? includeTotalCount;

  ClientSearchObject({
    this.fts,
    this.firstNameGTE,
    this.lastNameGTE,
    this.email,
    this.employmentStatus,
    this.page,
    this.sortBy,
    this.sortAscending,
    this.additionalData,
    this.includeTotalCount,
  });

  factory ClientSearchObject.fromJson(Map<String, dynamic> json) =>
      _$ClientSearchObjectFromJson(json);

  Map<String, dynamic> toJson() => _$ClientSearchObjectToJson(this);
}
