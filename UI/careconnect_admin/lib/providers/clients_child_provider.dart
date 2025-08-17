import 'dart:convert';

import 'package:careconnect_admin/models/responses/child.dart';
import 'package:careconnect_admin/models/responses/clients_child.dart';
import 'package:careconnect_admin/models/responses/clients_child_statistics.dart';
import 'package:careconnect_admin/models/responses/search_result.dart';
import 'package:careconnect_admin/models/search_objects/child_search_object.dart';
import 'package:careconnect_admin/models/search_objects/client_additional_data.dart';
import 'package:careconnect_admin/models/search_objects/client_search_object.dart';
import 'package:careconnect_admin/models/search_objects/clients_child_additional_data.dart';
import 'package:careconnect_admin/models/search_objects/clients_child_search_object.dart';
import 'package:careconnect_admin/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class ClientsChildProvider extends BaseProvider<ClientsChild> {
  ClientsChildProvider() : super("ClientsChild");

  @override
  ClientsChild fromJson(data) {
    return ClientsChild.fromJson(data);
  }

  Future<ClientsChildStatistics> getStatistics() async {
    var url = "$baseUrl$endpoint/statistics";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      notifyListeners();

      print(data);

      final stats = ClientsChildStatistics.fromJson(data);

      return stats;
    } else {
      throw new Exception("Unknown error");
    }
  }

  Future<ClientsChild> updateComposite(
    int clientId,
    int childId, [
    dynamic request,
  ]) async {
    var url = "$baseUrl$endpoint/$clientId";
    var uri = Uri.parse(url);
    var headers = super.createHeaders();

    var jsonRequest = jsonEncode(request);
    var response = await http.put(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      var updated = fromJson(data);

      var index = item.result.indexWhere(
        (e) => getClientId(e) == clientId && getChildId(e) == childId,
      );

      if (index != -1) {
        item.result[index] = updated;
        notifyListeners();
      }

      return updated;
    } else {
      throw Exception("Unknown error");
    }
  }

  int? getClientId(ClientsChild item) {
    return item.client.user?.userId;
  }

  int? getChildId(ClientsChild item) {
    return item.child.childId;
  }

  Future<ClientsChild> addChildToClient(int id, [dynamic request]) async {
    var endpoint = "Client";

    var url = "$baseUrl$endpoint/$id/children";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var jsonRequest = jsonEncode(request);
    var response = await http.post(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      var inserted = fromJson(data);
      item.result.add(inserted);
      notifyListeners();
      return inserted;
    } else {
      throw new Exception("Unknown error");
    }
  }

  Future<List<Child>> getChildren(int id) async {
    var endpoint = "Client";

    var url = "$baseUrl$endpoint/$id/children";

    // var queryString = getQueryString(id);
    // url = "$url?$queryString";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      print('Decoded data: $data');

      List<Child> result = (data as List)
          .map((item) => Child.fromJson(item))
          .toList();

      notifyListeners();

      return result;
    } else {
      throw new Exception("Unknown error");
    }
  }

  Future<bool> removeChildFromClient(int clientId, int childId) async {
    var endpoint = "Client";

    var url = "$baseUrl$endpoint/$clientId/$childId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.delete(uri, headers: headers);

    if (isValidResponse(response)) {
      final data = jsonDecode(response.body);
      final success = data;

      if (success == true) {
        final index = item.result.indexWhere(
          (e) => getChildId(e) == childId && getClientId(e) == clientId,
        );
        if (index != -1) {
          item.result.removeAt(index);
          notifyListeners();
        }
      }

      return success == true;
    } else {
      throw new Exception("Unknown error");
    }
  }

  Future<ClientsChild?> getClientAndChildById({
    int? clientId,
    int? childId,
  }) async {
    if (clientId == null || childId == null) return null;

    var url = "$baseUrl$endpoint/$clientId/$childId";

    // var queryString = getQueryString(id);
    // url = "$url?$queryString";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      print('Decoded data: $data');

      // List<Child> result = (data as List)
      //     .map((item) => Child.fromJson(item))
      //     .toList();

      ClientsChild result = ClientsChild.fromJson(data);

      notifyListeners();

      return result;
    } else {
      throw new Exception("Unknown error");
    }
  }

  Future<SearchResult<ClientsChild>?> loadData({
    String? fts,
    String? firstNameGTE,
    String? lastNameGTE,
    String? email,
    bool? employmentStatus,
    DateTime? birthDateGTE,
    DateTime? birthDateLTE,
    String? gender,
    int page = 0,
    String? sortBy,
    bool sortAscending = true,
  }) async {
    final clientFilterObject = ClientSearchObject(
      fts: fts,
      firstNameGTE: firstNameGTE,
      lastNameGTE: lastNameGTE,
      email: email,
      employmentStatus: employmentStatus,
      page: page,
      sortBy: sortBy,
      sortAscending: sortAscending,
      additionalData: ClientAdditionalData(isUserIncluded: true),
      includeTotalCount: true,
    );

    final childFilterObject = ChildSearchObject(
      fts: fts,
      firstNameGTE: firstNameGTE,
      lastNameGTE: lastNameGTE,
      birthDateGTE: birthDateGTE,
      birthDateLTE: birthDateLTE,
      gender: gender,
      page: page,
      sortBy: sortBy,
      sortAscending: sortAscending,
      includeTotalCount: true,
    );

    final filterObject = ClientsChildSearchObject(
      clientSearchObject: clientFilterObject,
      childSearchObject: childFilterObject,
      fts: fts,
      includeTotalCount: true,
      page: page,
      sortBy: sortBy,
      sortAscending: sortAscending,
      additionalData: ClientsChildAdditionalData(
        isChildIncluded: true,
        isClientIncluded: true,
      ),
    );

    final filter = filterObject.toJson();

    final result = await get(filter: filter);

    notifyListeners();
    return result;
  }

  Future<ClientsChildStatistics> loadStats() async {
    final statistics = await getStatistics();
    notifyListeners();
    return statistics;
  }
}
