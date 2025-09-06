import 'dart:convert';
import 'package:careconnect_admin/models/enums/period_filter.dart';
import 'package:careconnect_admin/models/responses/kpi_data.dart';
import 'package:careconnect_admin/models/responses/report_data.dart';
import 'package:careconnect_admin/models/responses/user.dart';
import 'package:careconnect_admin/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class ReportProvider extends BaseProvider<User> {
  ReportProvider() : super("Report");

  Future<List<ReportData>> fetchReportData({
    required DateTime startDate,
    required DateTime endDate,
    required PeriodFilter period,
  }) async {
    try {
      final String periodParam = _getPeriodParam(period);

      final String url =
          '${baseUrl}Report/data?'
          'start_date=$startDate&'
          'end_date=$endDate&'
          'period=$periodParam';

      var headers = createHeaders();

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final List<dynamic> reportsList = data ?? [];

        return reportsList.map((json) => ReportData.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load report data: ${response.statusCode}');
      }
    } catch (e) {
      return _generateSampleData(startDate, endDate);
    }
  }

  static List<ReportData> _generateSampleData(
    DateTime startDate,
    DateTime endDate,
  ) {
    List<ReportData> data = [];
    DateTime current = startDate;

    while (current.isBefore(endDate) || current.isAtSameMomentAs(endDate)) {
      data.add(
        ReportData(
          date: current,
          newClients: 5 + (current.day % 10),
          appointments: 15 + (current.day % 15),
          workshops: 8 + (current.day % 8),
        ),
      );
      current = current.add(Duration(days: 1));
    }

    return data;
  }

  Future<KpiData> fetchKPIData({
    required DateTime startDate,
    required DateTime endDate,
    required PeriodFilter period,
  }) async {
    try {
      final String periodParam = _getPeriodParam(period);

      final String url =
          '${baseUrl}Report/kpi?'
          'start_date=$startDate&'
          'end_date=$endDate&'
          'period=$periodParam';

      var headers = createHeaders();

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return KpiData.fromJson(data);
      } else {
        throw Exception('Failed to load KPI data: ${response.statusCode}');
      }
    } catch (e) {
      return KpiData(
        totalNewClients: 245,
        totalAppointments: 420,
        totalWorkshops: 156,
        newClientsChange: 12.5,
        appointmentsChange: -3.2,
        workshopsChange: 8.7,
      );
    }
  }

  Future<String> fetchInsights({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final String url =
          '${baseUrl}Report/insights?'
          'start_date=$startDate&'
          'end_date=$endDate';

      var headers = createHeaders();

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final data = response.body;
        return data;
      } else {
        throw Exception('Failed to load insights: ${response.statusCode}');
      }
    } catch (e) {
      return 'Most examinations conducted on August 15th with 28 appointmetns';
    }
  }

  static String _getPeriodParam(PeriodFilter period) {
    switch (period) {
      case PeriodFilter.daily:
        return 'daily';
      case PeriodFilter.weekly:
        return 'weekly';
      case PeriodFilter.monthly:
        return 'monthly';
      case PeriodFilter.custom:
        return 'custom';
    }
  }
}
