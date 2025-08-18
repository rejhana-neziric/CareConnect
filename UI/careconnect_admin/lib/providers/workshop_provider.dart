import 'dart:convert';
import 'package:careconnect_admin/models/responses/search_result.dart';
import 'package:careconnect_admin/models/responses/workshop.dart';
import 'package:careconnect_admin/models/responses/workshop_statistics.dart';
import 'package:careconnect_admin/models/search_objects/workshop_additional_data.dart';
import 'package:careconnect_admin/models/search_objects/workshop_search_object.dart';
import 'package:careconnect_admin/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class WorkshopProvider extends BaseProvider<Workshop> {
  WorkshopProvider() : super("Workshop");

  @override
  Workshop fromJson(data) {
    return Workshop.fromJson(data);
  }

  @override
  int? getId(Workshop item) {
    return item.workshopId;
  }

  Future<WorkshopStatistics> getStatistics() async {
    var url = "$baseUrl$endpoint/statistics";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      notifyListeners();

      final stats = WorkshopStatistics.fromJson(data);

      return stats;
    } else {
      throw Exception("Unknown error");
    }
  }

  Future<SearchResult<Workshop>?> loadData({
    String? fts,
    String? nameGTE,
    String? status,
    DateTime? startDateGTE,
    DateTime? startDateLTE,
    DateTime? endDateGTE,
    DateTime? endDateLTE,
    double? price,
    double? memberPrice,
    int? maxParticipants,
    int? participants,
    String? workshopType,
    int page = 0,
    String? sortBy,
    bool sortAscending = true,
  }) async {
    final filterObject = WorkshopSearchObject(
      fts: fts,
      nameGTE: nameGTE,
      status: status,
      startDateGTE: startDateGTE,
      startDateLTE: startDateLTE,
      endDateGTE: endDateGTE,
      endDateLTE: endDateLTE,
      price: price,
      memberPrice: memberPrice,
      maxParticipants: maxParticipants,
      participants: participants,
      workshopType: workshopType,
      additionalData: WorkshopAdditionalData(isWorkshopTypeIncluded: true),
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

  Future<WorkshopStatistics> loadStats() async {
    final statistics = await getStatistics();
    notifyListeners();
    return statistics;
  }
}
