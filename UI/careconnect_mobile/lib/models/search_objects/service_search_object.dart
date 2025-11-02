import 'package:json_annotation/json_annotation.dart';

part 'service_search_object.g.dart';

@JsonSerializable(explicitToJson: true)
class ServiceSearchObject {
  String? fts;
  String? nameGTE;
  double? price;
  bool? isActive;
  int? serviceTypeId;
  int? page;
  String? sortBy;
  bool? sortAscending;
  bool? includeTotalCount;
  bool? retrieveAll;

  ServiceSearchObject({
    this.fts,
    this.nameGTE,
    this.price,
    this.isActive,
    this.serviceTypeId,
    this.page,
    this.sortBy,
    this.sortAscending,
    this.includeTotalCount,
    this.retrieveAll,
  });

  factory ServiceSearchObject.fromJson(Map<String, dynamic> json) =>
      _$ServiceSearchObjectFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceSearchObjectToJson(this);
}
