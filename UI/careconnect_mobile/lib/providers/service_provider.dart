import 'package:careconnect_mobile/models/responses/search_result.dart';
import 'package:careconnect_mobile/models/responses/service.dart';
import 'package:careconnect_mobile/models/search_objects/service_search_object.dart';
import 'package:careconnect_mobile/providers/base_provider.dart';

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

  Future<SearchResult<Service>?> loadData({
    String? fts,
    double? price,
    double? memberPrice,
    bool? isActive,
    int? serviceTypeId,
    int page = 0,
    String? sortBy,
    bool sortAscending = true,
  }) async {
    final filterObject = ServiceSearchObject(
      nameGTE: fts,
      price: price,
      memberPrice: memberPrice,
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
}
