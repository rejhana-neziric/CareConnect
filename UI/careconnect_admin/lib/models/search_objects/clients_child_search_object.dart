import 'package:careconnect_admin/models/search_objects/child_search_object.dart';
import 'package:careconnect_admin/models/search_objects/client_search_object.dart';
import 'package:careconnect_admin/models/search_objects/clients_child_additional_data.dart';

import 'package:json_annotation/json_annotation.dart';

part 'clients_child_search_object.g.dart';

@JsonSerializable(explicitToJson: true)
class ClientsChildSearchObject {
  ClientSearchObject? clientSearchObject;
  ChildSearchObject? childSearchObject;
  String? fts;
  int? page;
  String? sortBy;
  bool? sortAscending;
  ClientsChildAdditionalData? additionalData;
  bool? includeTotalCount;

  ClientsChildSearchObject({
    this.clientSearchObject,
    this.childSearchObject,
    this.fts,
    this.page,
    this.sortBy,
    this.sortAscending,
    this.additionalData,
    this.includeTotalCount,
  });

  factory ClientsChildSearchObject.fromJson(Map<String, dynamic> json) =>
      _$ClientsChildSearchObjectFromJson(json);

  Map<String, dynamic> toJson() => _$ClientsChildSearchObjectToJson(this);
}
