import 'dart:convert';

import 'package:careconnect_mobile/models/requests/appointment_insert_request.dart';
import 'package:careconnect_mobile/models/requests/appointment_reschedule_request.dart';
import 'package:careconnect_mobile/models/requests/payment_intent_request.dart';
import 'package:careconnect_mobile/models/responses/appointment.dart';
import 'package:careconnect_mobile/models/responses/client.dart';
import 'package:careconnect_mobile/models/responses/search_result.dart';
import 'package:careconnect_mobile/models/search_objects/appointment_additional_data.dart';
import 'package:careconnect_mobile/models/search_objects/appointment_search_object.dart';
import 'package:careconnect_mobile/providers/base_provider.dart';
import 'package:careconnect_mobile/providers/payment_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AppointmentProvider extends BaseProvider<Appointment> {
  AppointmentProvider() : super("Appointment");

  @override
  Appointment fromJson(data) {
    return Appointment.fromJson(data);
  }

  @override
  int? getId(Appointment item) {
    return item.appointmentId;
  }

  Future<SearchResult<Appointment>?> loadData({
    String? fts,
    String? appointmentType,
    DateTime? dateGTE,
    DateTime? dateLTE,
    String? attendanceStatusName,
    String? employeeFirstName,
    String? employeeLastName,
    String? childFirstName,
    String? childLastName,
    String? startTime,
    String? endTime,
    String? status,
    int? clientId,
    int? childId,
    int? serviceTypeId,
    String? clientUsername,
    String? serviceNameGTE,
    int? employeeAvailabilityId,
    DateTime? date,

    int page = 0,
    String? sortBy,
    bool sortAscending = true,
    bool? retrieveAll,
  }) async {
    final filterObject = AppointmentSearchObject(
      fts: fts,
      appointmentType: appointmentType,
      dateGTE: dateGTE,
      dateLTE: dateLTE,
      attendanceStatusName: attendanceStatusName,
      employeeFirstName: employeeFirstName,
      employeeLastName: employeeLastName,
      childFirstName: childFirstName,
      childLastName: childLastName,
      startTime: startTime,
      endTime: endTime,
      status: status,
      clientId: clientId,
      childId: childId,
      clientUsername: clientUsername,
      serviceTypeId: serviceTypeId,
      serviceNameGTE: serviceNameGTE,
      employeeAvailabilityId: employeeAvailabilityId,
      date: date,
      page: page,
      sortBy: sortBy,
      sortAscending: sortAscending,
      additionalData: AppointmentAdditionalData(
        isClientsChildIncluded: true,
        isAttendanceStatusIncluded: true,
        isEmployeeAvailabilityIncluded: true,
      ),
      includeTotalCount: true,
      retrieveAll: retrieveAll,
    );

    final filter = filterObject.toJson();

    final result = await get(filter: filter);

    notifyListeners();
    return result;
  }

  Future<List<String>> getAppoinmentTypes() async {
    var url = "$baseUrl$endpoint/appointment-types";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      List<String> result = [];

      for (var item in data) {
        result.add(item.toString());
      }

      return result;
    } else {
      throw new Exception("Unknown error");
    }
  }

  Future<bool> processPayment({
    required BuildContext context,
    required double amount,
    required Client client,
    required AppointmentInsertRequest appointment,
  }) async {
    try {
      final paymentProvider = context.read<PaymentProvider>();

      final request = PaymentIntentRequest(
        clientId: appointment.clientId,
        childId: appointment.childId,
        itemId: null,
        itemType: "Appointment",
        appointment: appointment,
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

      appointment.paymentIntentId = paymentIntentResponse.paymentIntentId;

      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: json.encode(appointment),
      );

      final bookingSuccess = response.statusCode == 200;

      if (!bookingSuccess) {
        throw Exception('Scheduling failed after payment.');
      }

      return true;
    } on StripeException catch (e) {
      debugPrint('Stripe error: ${e.error.localizedMessage}');
      return false;
    } catch (e) {
      debugPrint('processPayment error: $e');
      return false;
    }
  }

  Future<bool> enrollInFreeItem({
    required BuildContext context,
    required AppointmentInsertRequest appointment,
  }) async {
    try {
      final headers = createHeaders();

      appointment.paymentIntentId = null;

      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: json.encode(appointment),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _updateAppointmentStatus({
    required int appointmentId,
    required String actionPath,
  }) async {
    final url = '$baseUrl$endpoint/$appointmentId/$actionPath';
    final uri = Uri.parse(url);
    final headers = createHeaders();

    final response = await http.put(uri, headers: headers);

    if (isValidResponse(response)) {
      final data = jsonDecode(response.body);
      final updated = fromJson(data);
      final index = item.result.indexWhere((e) => getId(e) == appointmentId);
      if (index != -1) {
        item.result[index] = updated;
        notifyListeners();
      }
      return true;
    }

    return false;
  }

  Future<bool> cancelAppointment({required int appointmentId}) {
    return _updateAppointmentStatus(
      appointmentId: appointmentId,
      actionPath: 'cancel',
    );
  }

  Future<bool> requestNewAppointmentTime({
    required int appointmentId,
    required AppointmentRescheduleRequest request,
  }) async {
    final url = '$baseUrl$endpoint/$appointmentId/reschedule-pending-approval';
    final uri = Uri.parse(url);
    final headers = createHeaders();

    var jsonRequest = jsonEncode(request);

    final response = await http.put(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      final data = jsonDecode(response.body);
      final updated = fromJson(data);
      final index = item.result.indexWhere((e) => getId(e) == appointmentId);
      if (index != -1) {
        item.result[index] = updated;
        notifyListeners();
      }
      return true;
    }

    return false;
  }
}
