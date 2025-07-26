import 'dart:convert';

import 'package:careconnect_admin/models/responses/clients_child.dart';
import 'package:careconnect_admin/models/responses/clients_child_statistics.dart';
import 'package:careconnect_admin/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class ClientsChildProvider extends BaseProvider<ClientsChild> {
  ClientsChildProvider() : super("ClientsChild");

  @override
  ClientsChild fromJson(data) {
    return ClientsChild.fromJson(data);
  }

  Future<ClientsChildStatistics> getStatistics() async {
    var url = "${baseUrl}$endpoint/statistics";
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
}
