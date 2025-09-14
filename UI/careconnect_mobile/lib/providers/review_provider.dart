import 'dart:convert';

import 'package:careconnect_mobile/models/responses/review.dart';
import 'package:careconnect_mobile/models/responses/search_result.dart';
import 'package:careconnect_mobile/models/search_objects/review_additional_data.dart';
import 'package:careconnect_mobile/models/search_objects/review_search_object.dart';
import 'package:careconnect_mobile/providers/base_provider.dart';

import 'package:http/http.dart' as http;

class ReviewProvider extends BaseProvider<Review> {
  ReviewProvider() : super("Review");

  @override
  Review fromJson(data) {
    return Review.fromJson(data);
  }

  @override
  int? getId(Review item) {
    return item.reviewId;
  }

  Future<SearchResult<Review>?> loadData({
    String? fts,
    String? titleGTE,
    bool? isHidden,
    DateTime? publishDateGTE,
    DateTime? publishDateLTE,
    int? stars,
    String? userFirstNameGTE,
    String? userLastNameGTE,
    String? employeeFirstNameGTE,
    String? employeeLastNameGTE,
    int? employeeId,
    int page = 0,
    String? sortBy,
    bool sortAscending = true,
  }) async {
    final filterObject = ReviewSearchObject(
      fts: fts,
      titleGTE: titleGTE,
      isHidden: isHidden,
      publishDateGTE: publishDateGTE,
      publishDateLTE: publishDateLTE,
      stars: stars,
      userFirstNameGTE: userFirstNameGTE,
      userLastNameGTE: userLastNameGTE,
      employeeFirstNameGTE: employeeFirstNameGTE,
      employeeLastNameGTE: employeeLastNameGTE,
      employeeId: employeeId,
      page: page,
      sortBy: sortBy,
      sortAscending: sortAscending,
      includeTotalCount: true,
      retrieveAll: true,
      additionalData: ReviewAdditionalData(
        isEmployeeIncluded: true,
        isUserIncluded: true,
      ),
    );

    final filter = filterObject.toJson();

    final result = await get(filter: filter);

    notifyListeners();
    return result;
  }

  Future<double> getAverage({int? employeeId}) async {
    var url = "$baseUrl$endpoint/average";

    if (employeeId != null) {
      var queryString = getQueryString({'employeeId': employeeId});
      url = "$url?$queryString";
    }
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      double average = (data as num).toDouble();

      notifyListeners();

      return average;
    } else {
      throw new Exception("Unknown error");
    }
  }
}
