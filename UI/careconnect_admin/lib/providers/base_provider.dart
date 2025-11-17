import 'dart:convert';
import 'package:careconnect_admin/core/config.dart';
import 'package:careconnect_admin/models/responses/search_result.dart';
import 'package:careconnect_admin/models/auth_credentials.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

abstract class BaseProvider<T> with ChangeNotifier {
  static String? _baseUrl;
  String _endpoint = "";

  SearchResult<T> _items = SearchResult<T>();
  SearchResult<T> get item => _items;

  String get baseUrl => _baseUrl ?? "";
  String get endpoint => _endpoint;

  bool shouldRefresh = false;

  BaseProvider(String endpoint) {
    _endpoint = endpoint;
    _baseUrl = AppConfig.apiBaseUrl;
    // const String.fromEnvironment(
    //   "baseUrl",
    //   defaultValue: "http://localhost:5241/",
    // );
  }

  void markShouldRefresh() {
    shouldRefresh = true;
    notifyListeners();
  }

  void markRefreshed() {
    shouldRefresh = false;
  }

  Future<SearchResult<T>> get({dynamic filter}) async {
    var url = "$_baseUrl$_endpoint";

    if (filter != null) {
      var queryString = getQueryString(filter);
      url = "$url?$queryString";
    }

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      var result = SearchResult<T>();

      result.totalCount = data['totalCount'];

      _items = SearchResult<T>();

      for (var item in data['resultList']) {
        result.result.add(fromJson(item));
        _items = result;
      }

      notifyListeners();

      return result;
    } else {
      throw new Exception("Unknown error");
    }
  }

  Future<T> getById(int id, {dynamic filter}) async {
    var url = "$_baseUrl$_endpoint/$id";

    if (filter != null) {
      var queryString = getQueryString(filter);
      url = "$url?$queryString";
    }

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      T result = fromJson(data);

      notifyListeners();

      return result;
    } else {
      throw new Exception("Unknown error");
    }
  }

  Future<T> insert(dynamic request) async {
    var url = "$_baseUrl$_endpoint";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var jsonRequest = jsonEncode(request);
    var response = await http.post(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      var inserted = fromJson(data);
      _items.result.add(inserted);
      notifyListeners();
      return inserted;
    } else {
      throw new Exception("Unknown error");
    }
  }

  Future<T> update(int id, [dynamic request]) async {
    var url = "$_baseUrl$_endpoint/$id";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var jsonRequest = jsonEncode(request);
    var response = await http.put(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      var updated = fromJson(data);
      var index = _items.result.indexWhere((e) => getId(e) == id);
      if (index != -1) {
        _items.result[index] = updated;
        notifyListeners();
      }
      return fromJson(data);
    } else {
      throw new Exception("Unknown error");
    }
  }

  T fromJson(data) {
    throw Exception("Method not implemented");
  }

  int? getId(T item) {
    throw Exception("Method not implemented");
  }

  Future<Map<String, dynamic>> delete(int id) async {
    var url = "$_baseUrl$_endpoint/$id";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    try {
      var response = await http.delete(uri, headers: headers);

      if (isValidResponse(response)) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          final index = _items.result.indexWhere((e) => getId(e) == id);
          if (index != -1) {
            _items.result.removeAt(index);
            notifyListeners();
          }
        }

        return {
          'success': data['success'] ?? false,
          'message': data['message'] ?? 'Unknown error',
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to delete',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  bool isValidResponse(Response response) {
    if (response.statusCode < 299) {
      return true;
    } else if (response.statusCode == 401) {
      throw new Exception("Unauthorized");
    } else {
      throw new Exception("Something bad happened please try again");
    }
  }

  Map<String, String> createHeaders() {
    String username = AuthCredentials.username ?? "";
    String password = AuthCredentials.password ?? "";

    String basicAuth =
        "Basic ${base64Encode(utf8.encode('$username:$password'))}";

    var headers = {
      "Content-Type": "application/json",
      "Authorization": basicAuth,
    };

    return headers;
  }

  String getQueryString(
    Map params, {
    String prefix = '&',
    bool inRecursion = false,
  }) {
    String query = '';
    params.forEach((key, value) {
      if (inRecursion) {
        if (key is int) {
          key = '[$key]';
        } else if (value is List || value is Map) {
          key = '.$key';
        } else {
          key = '.$key';
        }
      }
      if (value is String || value is int || value is double || value is bool) {
        var encoded = value;
        if (value is String) {
          encoded = Uri.encodeComponent(value);
        }
        query += '$prefix$key=$encoded';
      } else if (value is DateTime) {
        query += '$prefix$key=${(value).toIso8601String()}';
      } else if (value is List || value is Map) {
        if (value is List) value = value.asMap();
        value.forEach((k, v) {
          query += getQueryString(
            {k: v},
            prefix: '$prefix$key',
            inRecursion: true,
          );
        });
      }
    });
    return query;
  }
}
