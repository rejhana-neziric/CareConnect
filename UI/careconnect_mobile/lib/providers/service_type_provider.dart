// import 'dart:convert';
import 'package:careconnect_mobile/models/responses/search_result.dart';
import 'package:careconnect_mobile/models/responses/service_type.dart';
import 'package:careconnect_mobile/models/search_objects/service_type_search_object.dart';
import 'package:careconnect_mobile/providers/base_provider.dart';
// import 'package:http/http.dart' as http;

class ServiceTypeProvider extends BaseProvider<ServiceType> {
  ServiceTypeProvider() : super("ServiceType");

  @override
  ServiceType fromJson(data) {
    return ServiceType.fromJson(data);
  }

  @override
  int? getId(ServiceType item) {
    return item.serviceTypeId;
  }

  Future<SearchResult<ServiceType>?> loadData({
    String? fts,
    int page = 0,
    String? sortBy,
    bool sortAscending = true,
  }) async {
    final filterObject = ServiceTypeSearchObject(
      fts: fts,
      page: page,
      sortBy: sortBy,
      sortAscending: sortAscending,
      includeTotalCount: true,
      retrieveAll: true,
    );

    final filter = filterObject.toJson();

    final result = await get(filter: filter);

    notifyListeners();
    return result;
  }
}
