import 'dart:convert';
import 'package:careconnect_mobile/models/requests/enrollment_request.dart';
import 'package:careconnect_mobile/models/requests/payment_intent_request.dart';
import 'package:careconnect_mobile/models/responses/client.dart';
import 'package:careconnect_mobile/models/responses/search_result.dart';
import 'package:careconnect_mobile/models/responses/workshop.dart';
import 'package:careconnect_mobile/models/responses/workshop_statistics.dart';
import 'package:careconnect_mobile/models/search_objects/workshop_search_object.dart';
import 'package:careconnect_mobile/providers/base_provider.dart';
import 'package:careconnect_mobile/providers/payment_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

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

  dynamic parseResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception("Unauthorized");
    } else {
      try {
        final data = jsonDecode(response.body);
        return data;
      } catch (_) {
        throw Exception("Unexpected error: ${response.body}");
      }
    }
  }

  Future<bool> enroll({required EnrollmentRequest requests}) async {
    var headers = createHeaders();

    final response = await http.post(
      Uri.parse('$baseUrl$endpoint/enroll'),
      headers: headers,
      body: json.encode(requests),
    );

    return response.statusCode == 200;
  }

  Future<bool> isEnrolledInWorkshop({
    required int workshopId,
    required clientId,
    int? childId,
  }) async {
    var headers = createHeaders();

    final queryParams = {
      'clientId': clientId.toString(),
      if (childId != null) 'childId': childId.toString(),
    };

    final uri = Uri.parse(
      '$baseUrl$endpoint/$workshopId/status',
    ).replace(queryParameters: queryParams);

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['isEnrolled'] ?? false;
    }
    return false;
  }

  Future<bool> processPayment({
    required BuildContext context,
    required double amount,
    required int clientId,
    required Client client,
    required int workshopId,
    int? childId,
  }) async {
    try {
      final paymentProvider = context.read<PaymentProvider>();

      final request = PaymentIntentRequest(
        clientId: clientId,
        childId: childId,
        itemId: workshopId,
        itemType: "Workshop",
        appointment: null,
      );

      // Create payment intent
      final paymentIntentResponse = await paymentProvider.createPaymentIntent(
        requests: request,
      );

      // Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentResponse.clientSecret,
          merchantDisplayName: 'CareConnect',
          style: ThemeMode.system,
          billingDetails: BillingDetails(
            name: '${client.user?.firstName} ${client.user?.lastName}',
            email: client.user?.email,
          ),
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      // Verify payment
      final isPaymentVerified = await paymentProvider.verifyPayment(
        paymentIntentResponse.paymentIntentId,
      );

      if (!isPaymentVerified) {
        throw Exception('Payment verification failed');
      }

      final headers = createHeaders();

      final enrollmentRequest = EnrollmentRequest(
        clientId: clientId,
        childId: childId,
        workshopId: workshopId,
        paymentIntentId: paymentIntentResponse.paymentIntentId,
      );

      final response = await http.post(
        Uri.parse('$baseUrl$endpoint/enroll'),
        headers: headers,
        body: json.encode(enrollmentRequest),
      );

      final enrollmentSuccess = response.statusCode == 200;

      if (!enrollmentSuccess) {
        throw Exception('Enrollment failed after payment');
      }

      return true;
    } on StripeException {
      return false;
    } catch (e) {
      Navigator.of(context).pop();

      return false;
    }
  }

  Future<bool> enrollInFreeItem({
    required BuildContext context,
    required int clientId,
    required int workshopId,
    int? childId,
  }) async {
    try {
      final headers = createHeaders();

      final request = EnrollmentRequest(
        clientId: clientId,
        childId: childId,
        workshopId: workshopId,
        paymentIntentId: null,
      );

      final response = await http.post(
        Uri.parse('$baseUrl$endpoint/enroll'),
        headers: headers,
        body: json.encode(request),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
