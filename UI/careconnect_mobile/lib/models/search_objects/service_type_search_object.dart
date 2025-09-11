import 'package:json_annotation/json_annotation.dart';

part 'service_type_search_object.g.dart';

@JsonSerializable(explicitToJson: true)
class ServiceTypeSearchObject {
  String? fts;
  int? page;
  String? sortBy;
  bool? sortAscending;
  bool? includeTotalCount;
  bool? retrieveAll;

  ServiceTypeSearchObject({
    this.fts,
    this.page,
    this.sortBy,
    this.sortAscending,
    this.includeTotalCount,
    this.retrieveAll,
  });

  factory ServiceTypeSearchObject.fromJson(Map<String, dynamic> json) =>
      _$ServiceTypeSearchObjectFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceTypeSearchObjectToJson(this);
}
