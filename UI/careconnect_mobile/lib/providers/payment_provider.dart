import 'dart:convert';

import 'package:careconnect_mobile/models/requests/payment_intent_request.dart';
import 'package:careconnect_mobile/models/responses/payment_intent_response.dart';
import 'package:careconnect_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class PaymentProvider extends BaseProvider<void> {
  PaymentProvider() : super("Payment");

  @override
  void fromJson(data) {}

  @override
  int? getId(void item) {
    return null;
  }

  Future<PaymentIntentResponse> createPaymentIntent({
    required PaymentIntentRequest requests,
  }) async {
    var headers = createHeaders();

    final response = await http.post(
      Uri.parse('${baseUrl}Payment/create-intent'),
      headers: headers,
      body: json.encode(requests.toJson()),
    );

    if (response.statusCode == 200) {
      return PaymentIntentResponse.fromJson(json.decode(response.body));
    } else {
      final error = json.decode(response.body);
      throw Exception(error['error'] ?? 'Failed to create payment intent');
    }
  }

  Future<bool> verifyPayment(String paymentIntentId) async {
    var headers = createHeaders();

    final response = await http.get(
      Uri.parse('${baseUrl}Payment/verify/$paymentIntentId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['isValid'] ?? false;
    }
    return false;
  }
}
