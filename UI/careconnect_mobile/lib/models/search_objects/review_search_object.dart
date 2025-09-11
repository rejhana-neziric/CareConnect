import 'package:careconnect_mobile/models/search_objects/review_additional_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'review_search_object.g.dart';

@JsonSerializable(explicitToJson: true)
class ReviewSearchObject {
  String? fts;
  String? titleGTE;
  bool? isHidden;
  DateTime? publishDateGTE;
  DateTime? publishDateLTE;
  int? stars;
  String? userFirstNameGTE;
  String? userLastNameGTE;
  String? employeeFirstNameGTE;
  String? employeeLastNameGTE;
  ReviewAdditionalData? additionalData;
  int? page;
  String? sortBy;
  bool? sortAscending;
  bool? includeTotalCount;
  bool? retrieveAll;

  ReviewSearchObject({
    this.fts,
    this.titleGTE,
    this.isHidden,
    this.publishDateGTE,
    this.publishDateLTE,
    this.stars,
    this.userFirstNameGTE,
    this.userLastNameGTE,
    this.employeeFirstNameGTE,
    this.employeeLastNameGTE,
    this.additionalData,
    this.page,
    this.sortBy,
    this.sortAscending,
    this.includeTotalCount,
    this.retrieveAll,
  });

  factory ReviewSearchObject.fromJson(Map<String, dynamic> json) =>
      _$ReviewSearchObjectFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewSearchObjectToJson(this);
}
