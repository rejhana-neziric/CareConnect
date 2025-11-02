import 'dart:convert';
import 'package:careconnect_admin/models/responses/search_result.dart';
import 'package:careconnect_admin/models/responses/service.dart';
import 'package:careconnect_admin/models/responses/service_statistics.dart';
import 'package:careconnect_admin/models/search_objects/service_search_object.dart';
import 'package:careconnect_admin/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class ServiceProvider extends BaseProvider<Service> {
  ServiceProvider() : super("Service");

  @override
  Service fromJson(data) {
    return Service.fromJson(data);
  }

  @override
  int? getId(Service item) {
    return item.serviceId;
  }

  Future<ServiceStatistics> getStatistics() async {
    var url = "$baseUrl$endpoint/statistics";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      notifyListeners();

      final stats = ServiceStatistics.fromJson(data);

      return stats;
    } else {
      throw Exception("Unknown error");
    }
  }

  Future<SearchResult<Service>?> loadData({
    String? fts,
    double? price,
    bool? isActive,
    int? serviceTypeId,
    int page = 0,
    String? sortBy,
    bool sortAscending = true,
  }) async {
    final filterObject = ServiceSearchObject(
      nameGTE: fts,
      price: price,
      isActive: isActive,
      serviceTypeId: serviceTypeId,
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

  Future<ServiceStatistics> loadStats() async {
    final statistics = await getStatistics();
    notifyListeners();
    return statistics;
  }
}
