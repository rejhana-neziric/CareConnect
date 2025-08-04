import 'package:json_annotation/json_annotation.dart';

part 'service_search_object.g.dart';

@JsonSerializable(explicitToJson: true)
class ServiceSearchObject {
  String? fts;
  String? nameGTE;
  double? price;
  double? memberPrice;
  int? page;
  String? sortBy;
  bool? sortAscending;
  bool? includeTotalCount;
  bool? retrieveAll;

  ServiceSearchObject({
    this.fts,
    this.nameGTE,
    this.price,
    this.memberPrice,
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
