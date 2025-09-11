import 'package:careconnect_mobile/models/search_objects/child_additional_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'child_search_object.g.dart';

@JsonSerializable(explicitToJson: true)
class ChildSearchObject {
  String? fts;
  String? firstNameGTE;
  String? lastNameGTE;
  DateTime? birthDateGTE;
  DateTime? birthDateLTE;
  String? gender;
  int? page;
  String? sortBy;
  bool? sortAscending;
  ChildAdditionalData? additionalData;
  bool? includeTotalCount;

  ChildSearchObject({
    this.fts,
    this.firstNameGTE,
    this.lastNameGTE,
    this.birthDateGTE,
    this.birthDateLTE,
    this.gender,
    this.page,
    this.sortBy,
    this.sortAscending,
    this.additionalData,
    this.includeTotalCount,
  });

  factory ChildSearchObject.fromJson(Map<String, dynamic> json) =>
      _$ChildSearchObjectFromJson(json);

  Map<String, dynamic> toJson() => _$ChildSearchObjectToJson(this);
}
