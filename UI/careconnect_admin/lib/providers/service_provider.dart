import 'dart:convert';

import 'package:careconnect_admin/models/responses/service.dart';
import 'package:careconnect_admin/models/responses/service_statistics.dart';
import 'package:careconnect_admin/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class ServiceProvider extends BaseProvider<Service> {
  ServiceProvider() : super("Service");

  @override
  Service fromJson(data) {
    return Service.fromJson(data);
  }

  // @override
  // int? getId(Service item) {
  //   return item.id;
  // }

  Future<ServiceStatistics> getStatistics() async {
    var url = "$baseUrl$endpoint/statistics";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      notifyListeners();

      print(data);

      final stats = ServiceStatistics.fromJson(data);

      return stats;
    } else {
      throw new Exception("Unknown error");
    }
  }
}
