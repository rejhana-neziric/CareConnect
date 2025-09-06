import 'package:careconnect_admin/core/layouts/master_screen.dart';
import 'package:careconnect_admin/models/enums/period_filter.dart';
import 'package:careconnect_admin/models/responses/kpi_data.dart';
import 'package:careconnect_admin/models/responses/report_data.dart';
import 'package:careconnect_admin/providers/report_provider.dart';
import 'package:careconnect_admin/widgets/snackbar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';

enum ChartType { line, bar }

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  PeriodFilter selectedPeriod = PeriodFilter.monthly;
  ChartType selectedChartType = ChartType.bar;
  DateTime startDate = DateTime.now().subtract(Duration(days: 30));
  DateTime endDate = DateTime.now();

  List<ReportData> reportData = [];
  KpiData? kpiData;
  String highlightInsight = "";
  bool isLoading = true;
  String? errorMessage;

  late ReportProvider reportProvider;

  @override
  void initState() {
    super.initState();
    reportProvider = context.read<ReportProvider>();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final futures = await Future.wait([
        reportProvider.fetchReportData(
          startDate: startDate,
          endDate: endDate,
          period: selectedPeriod,
        ),
        reportProvider.fetchKPIData(
          startDate: startDate,
          endDate: endDate,
          period: selectedPeriod,
        ),
        reportProvider.fetchInsights(startDate: startDate, endDate: endDate),
      ]);

      setState(() {
        reportData = futures[0] as List<ReportData>;
        kpiData = futures[1] as KpiData;
        highlightInsight = futures[2] as String;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    await _loadData();
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: startDate, end: endDate),
    );

    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
        selectedPeriod = PeriodFilter.custom;
      });
      await _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MasterScreen(
      "Report",
      Scaffold(
        backgroundColor: colorScheme.surfaceContainerLow,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Reports Dashboard',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          backgroundColor: colorScheme.surfaceContainerLow,
          foregroundColor: colorScheme.onSurface,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _refreshData,
              tooltip: 'Refresh Data',
            ),
            IconButton(
              icon: Icon(Icons.date_range),
              onPressed: _selectDateRange,
              tooltip: 'Select Date Range',
            ),
          ],
        ),
        body: isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading reports data...'),
                  ],
                ),
              )
            : errorMessage != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red),
                    SizedBox(height: 16),
                    Text(errorMessage!, textAlign: TextAlign.center),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _refreshData,
                      child: Text('Retry'),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFilterSection(colorScheme),
                    SizedBox(height: 20),
                    _buildKPICards(colorScheme),
                    SizedBox(height: 20),
                    _buildInsightCard(colorScheme),
                    SizedBox(height: 20),
                    _buildChartsSection(colorScheme),
                    SizedBox(height: 20),
                    _buildDataTable(),
                    SizedBox(height: 20),
                    _buildExportSection(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildFilterSection(ColorScheme colorScheme) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Filter Options',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                if (selectedPeriod == PeriodFilter.custom)
                  Text(
                    '${DateFormat('d. M. y.').format(startDate)} - ${DateFormat('d. M. y.').format(endDate)}',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Period',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 8),
                      DropdownButtonFormField<PeriodFilter>(
                        initialValue: selectedPeriod,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        items: PeriodFilter.values.map((period) {
                          return DropdownMenuItem(
                            value: period,
                            child: Text(_getPeriodName(period)),
                          );
                        }).toList(),
                        onChanged: (value) async {
                          if (value == PeriodFilter.custom) {
                            await _selectDateRange();
                          } else {
                            setState(() {
                              selectedPeriod = value!;
                              _updateDateRange();
                            });
                            await _loadData();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chart Type',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 8),
                      DropdownButtonFormField<ChartType>(
                        initialValue: selectedChartType,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        items: ChartType.values.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(
                              type == ChartType.line
                                  ? 'Line Chart'
                                  : 'Bar Chart',
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedChartType = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _updateDateRange() {
    DateTime now = DateTime.now();
    switch (selectedPeriod) {
      case PeriodFilter.daily:
        startDate = now.subtract(Duration(days: 7));
        endDate = now;
        break;
      case PeriodFilter.weekly:
        startDate = now.subtract(Duration(days: 28));
        endDate = now;
        break;
      case PeriodFilter.monthly:
        startDate = now.subtract(Duration(days: 90));
        endDate = now;
        break;
      case PeriodFilter.custom:
        break;
    }
  }

  String _getPeriodName(PeriodFilter period) {
    switch (period) {
      case PeriodFilter.daily:
        return 'Last 7 Days';
      case PeriodFilter.weekly:
        return 'Last 4 Weeks';
      case PeriodFilter.monthly:
        return 'Last 3 Months';
      case PeriodFilter.custom:
        return 'Custom Period';
    }
  }

  Widget _buildKPICards(ColorScheme colorScheme) {
    if (kpiData == null) return SizedBox.shrink();

    return Row(
      children: [
        Expanded(
          child: _buildKPICard(
            'New Clients',
            kpiData!.totalNewClients.toString(),
            kpiData!.newClientsChange,
            Icons.person_add,
            colorScheme.primaryContainer,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildKPICard(
            'Appointments',
            kpiData!.totalAppointments.toString(),
            kpiData!.appointmentsChange,
            Icons.calendar_month,
            colorScheme.primary,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildKPICard(
            'Workshops',
            kpiData!.totalWorkshops.toString(),
            kpiData!.workshopsChange,
            Icons.book,
            colorScheme.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildKPICard(
    String title,
    String value,
    double change,
    IconData icon,
    Color color,
  ) {
    bool isPositive = change >= 0;

    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                  color: isPositive ? Colors.green : Colors.red,
                  size: 16,
                ),
                SizedBox(width: 4),
                Text(
                  '${change.abs().toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: isPositive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'vs last period',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightCard(ColorScheme colorScheme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.surfaceContainerLowest,
              colorScheme.surfaceContainer,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.insights, color: Colors.amber, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Key Insight',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      highlightInsight,
                      style: TextStyle(color: colorScheme.onPrimaryContainer),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartsSection(ColorScheme colorScheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Card(
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Trends Over Time',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: 300,
                    child: reportData.isEmpty
                        ? Center(child: Text('No data available'))
                        : selectedChartType == ChartType.line
                        ? _buildLineChart(colorScheme)
                        : _buildBarChart(colorScheme),
                  ),
                  SizedBox(height: 16),
                  _buildLegend(colorScheme),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          flex: 1,
          child: Card(
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Distribution',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: 300,
                    child: kpiData == null
                        ? Center(child: Text('No data available'))
                        : _buildPieChart(colorScheme),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegend(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLegendItem('New Users', colorScheme.primaryContainer),
        _buildLegendItem('Examinations', colorScheme.primary),
        _buildLegendItem('Workshops', colorScheme.secondary),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(width: 16, height: 16, color: color),
        SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildLineChart(ColorScheme colorScheme) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: (reportData.length / 6).ceil().toDouble(),
              getTitlesWidget: (value, meta) {
                if (value.toInt() < reportData.length && value.toInt() >= 0) {
                  return Text(
                    DateFormat('dd/MM').format(reportData[value.toInt()].date),
                    style: TextStyle(fontSize: 10),
                  );
                }
                return Text('');
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: reportData
                .asMap()
                .entries
                .map(
                  (e) =>
                      FlSpot(e.key.toDouble(), e.value.newClients.toDouble()),
                )
                .toList(),
            isCurved: true,
            color: colorScheme.primaryContainer,
            barWidth: 3,
            dotData: FlDotData(show: false),
          ),
          LineChartBarData(
            spots: reportData
                .asMap()
                .entries
                .map(
                  (e) =>
                      FlSpot(e.key.toDouble(), e.value.appointments.toDouble()),
                )
                .toList(),
            isCurved: true,
            color: colorScheme.primary,
            barWidth: 3,
            dotData: FlDotData(show: false),
          ),
          LineChartBarData(
            spots: reportData
                .asMap()
                .entries
                .map(
                  (e) => FlSpot(e.key.toDouble(), e.value.workshops.toDouble()),
                )
                .toList(),
            isCurved: true,
            color: colorScheme.secondary,
            barWidth: 3,
            dotData: FlDotData(show: false),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(ColorScheme colorScheme) {
    return BarChart(
      BarChartData(
        gridData: FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: (reportData.length / 6).ceil().toDouble(),
              getTitlesWidget: (value, meta) {
                if (value.toInt() < reportData.length && value.toInt() >= 0) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      DateFormat(
                        'dd/MM',
                      ).format(reportData[value.toInt()].date),
                      style: TextStyle(fontSize: 10),
                    ),
                  );
                }
                return Text('');
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups: reportData.asMap().entries.map((e) {
          return BarChartGroupData(
            x: e.key,
            barRods: [
              BarChartRodData(
                toY: e.value.newClients.toDouble(),
                color: colorScheme.primaryContainer,
                width: 6,
                borderRadius: BorderRadius.circular(2),
              ),
              BarChartRodData(
                toY: e.value.appointments.toDouble(),
                color: colorScheme.primary,
                width: 6,
                borderRadius: BorderRadius.circular(2),
              ),
              BarChartRodData(
                toY: e.value.workshops.toDouble(),
                color: colorScheme.secondary,
                width: 6,
                borderRadius: BorderRadius.circular(2),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPieChart(ColorScheme colorScheme) {
    int totalUsers = kpiData?.totalNewClients ?? 0;
    int totalExaminations = kpiData?.totalAppointments ?? 0;
    int totalWorkshops = kpiData?.totalWorkshops ?? 0;
    int total = totalUsers + totalExaminations + totalWorkshops;

    if (total == 0) {
      return Center(child: Text('No data available'));
    }

    return Column(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: [
                PieChartSectionData(
                  color: colorScheme.primaryContainer,
                  value: totalUsers.toDouble(),
                  title: '${((totalUsers / total) * 100).toStringAsFixed(1)}%',
                  radius: 80,
                  titleStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                PieChartSectionData(
                  color: colorScheme.primary,
                  value: totalExaminations.toDouble(),
                  title:
                      '${((totalExaminations / total) * 100).toStringAsFixed(1)}%',
                  radius: 80,
                  titleStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                PieChartSectionData(
                  color: colorScheme.secondary,
                  value: totalWorkshops.toDouble(),
                  title:
                      '${((totalWorkshops / total) * 100).toStringAsFixed(1)}%',
                  radius: 80,
                  titleStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        Column(
          children: [
            _buildPieChartLegendItem(
              'New Clients',
              colorScheme.primaryContainer,
              totalUsers,
            ),
            SizedBox(height: 4),
            _buildPieChartLegendItem(
              'Appointments',
              colorScheme.primary,
              totalExaminations,
            ),
            SizedBox(height: 4),
            _buildPieChartLegendItem(
              'Workshops',
              colorScheme.secondary,
              totalWorkshops,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPieChartLegendItem(String label, Color color, int value) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 8),
        Expanded(child: Text('$label: $value', style: TextStyle(fontSize: 12))),
      ],
    );
  }

  Widget _buildDataTable() {
    return Center(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Detailed Data',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              if (reportData.isEmpty)
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text('No data available for the selected period'),
                  ),
                )
              else
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 20,
                    columns: [
                      DataColumn(
                        label: SizedBox(
                          width: 150,
                          child: Text(
                            'Date',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: SizedBox(
                          width: 150,
                          child: Center(
                            child: Text(
                              'New Clients',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        numeric: true,
                      ),
                      DataColumn(
                        label: SizedBox(
                          width: 150,
                          child: Center(
                            child: Text(
                              'Appointments',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        numeric: true,
                      ),
                      DataColumn(
                        label: SizedBox(
                          width: 150,
                          child: Center(
                            child: Text(
                              'Workshops',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        numeric: true,
                      ),
                      DataColumn(
                        label: SizedBox(
                          width: 150,
                          child: Center(
                            child: Text(
                              'Total',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        numeric: true,
                      ),
                    ],
                    rows: reportData.map((data) {
                      int total =
                          data.newClients + data.appointments + data.workshops;
                      return DataRow(
                        cells: [
                          DataCell(
                            Text(DateFormat('dd-MM-yyyy').format(data.date)),
                          ),
                          DataCell(
                            Center(child: Text(data.newClients.toString())),
                          ),
                          DataCell(
                            Center(child: Text(data.appointments.toString())),
                          ),
                          DataCell(
                            Center(child: Text(data.workshops.toString())),
                          ),
                          DataCell(
                            Center(
                              child: Text(
                                total.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExportSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Export Report',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Download reports for the period: ${DateFormat('dd MMM, yyyy').format(startDate)} - ${DateFormat('dd MMM, yyyy').format(endDate)}',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                SizedBox(
                  width: 300,
                  child: ElevatedButton.icon(
                    onPressed: reportData.isEmpty ? null : _exportToPDF,
                    icon: Icon(Icons.picture_as_pdf),
                    label: Text('Export to PDF'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      disabledBackgroundColor: Colors.grey[300],
                    ),
                  ),
                ),
                SizedBox(width: 16),
                SizedBox(
                  width: 300,
                  child: ElevatedButton.icon(
                    onPressed: reportData.isEmpty ? null : _exportToExcel,
                    icon: Icon(Icons.table_chart),
                    label: Text('Export to Excel'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      disabledBackgroundColor: Colors.grey[300],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<pw.Font> loadFont(String path) async {
    final data = await rootBundle.load(path);
    return pw.Font.ttf(data);
  }

  Future<void> _exportToPDF() async {
    try {
      final pdf = pw.Document();

      final fontRegular = await loadFont('assets/fonts/Roboto-Regular.ttf');
      final fontBold = await loadFont('assets/fonts/Roboto-Bold.ttf');

      pdf.addPage(
        pw.MultiPage(
          theme: pw.ThemeData.withFont(base: fontRegular, bold: fontBold),
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return [
              pw.Header(
                level: 0,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'CareConnect - Reports Dashboard',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'Period: ${DateFormat('dd MMM, yyyy').format(startDate)} - ${DateFormat('dd MMM, yyyy').format(endDate)}',
                      style: pw.TextStyle(
                        fontSize: 14,
                        color: PdfColors.grey600,
                      ),
                    ),
                    pw.Text(
                      'Generated on: ${DateFormat('dd MMM, yyyy HH:mm').format(DateTime.now())}',
                      style: pw.TextStyle(
                        fontSize: 12,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 32),

              // KPI Section
              pw.Text(
                'Key Performance Indicators',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 16),
              pw.Container(
                padding: pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                  children: [
                    pw.Column(
                      children: [
                        pw.Text(
                          'New Users',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          '${kpiData?.totalNewClients ?? 0}',
                          style: pw.TextStyle(fontSize: 24),
                        ),
                        pw.Text(
                          '${kpiData?.newClientsChange.toStringAsFixed(1)}%',
                          style: pw.TextStyle(
                            fontSize: 12,
                            color: PdfColors.green,
                          ),
                        ),
                      ],
                    ),
                    pw.Column(
                      children: [
                        pw.Text(
                          'Appointments',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          '${kpiData?.totalAppointments ?? 0}',
                          style: pw.TextStyle(fontSize: 24),
                        ),
                        pw.Text(
                          '${kpiData?.appointmentsChange.toStringAsFixed(1)}%',
                          style: pw.TextStyle(
                            fontSize: 12,
                            color: PdfColors.red,
                          ),
                        ),
                      ],
                    ),
                    pw.Column(
                      children: [
                        pw.Text(
                          'Workshops',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          '${kpiData?.totalWorkshops ?? 0}',
                          style: pw.TextStyle(fontSize: 24),
                        ),
                        pw.Text(
                          '${kpiData?.workshopsChange.toStringAsFixed(1)}%',
                          style: pw.TextStyle(
                            fontSize: 12,
                            color: PdfColors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 32),

              // Insight Section
              pw.Text(
                'Key Insight',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Container(
                padding: pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: PdfColors.amber50,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Text(highlightInsight),
              ),
              pw.SizedBox(height: 32),

              // Data Table
              pw.Text(
                'Detailed Data',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 16),
              pw.Table.fromTextArray(
                headers: [
                  'Date',
                  'New Clients',
                  'Appointments',
                  'Workshops',
                  'Total',
                ],
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                cellAlignment: pw.Alignment.center,
                data: reportData.map((data) {
                  int total =
                      data.newClients + data.appointments + data.workshops;
                  return [
                    DateFormat('dd-MM-yyyy').format(data.date),
                    data.newClients.toString(),
                    data.appointments.toString(),
                    data.workshops.toString(),
                    total.toString(),
                  ];
                }).toList(),
              ),

              pw.SizedBox(height: 32),
              pw.Text(
                'Summary Statistics',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Bullet(text: 'Total records: ${reportData.length}'),
              pw.Bullet(
                text:
                    'Average new clients per day: ${(kpiData?.totalNewClients ?? 0) / (reportData.length > 0 ? reportData.length : 1)}',
              ),
              pw.Bullet(
                text:
                    'Average appointments per day: ${(kpiData?.totalAppointments ?? 0) / (reportData.length > 0 ? reportData.length : 1)}',
              ),
              pw.Bullet(
                text:
                    'Average workshops per day: ${(kpiData?.totalNewClients ?? 0) / (reportData.length > 0 ? reportData.length : 1)}',
              ),
            ];
          },
        ),
      );

      String? outputPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save PDF Report',
        fileName:
            'careconnect_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf',
      );

      if (outputPath != null) {
        final file = File(outputPath);
        await file.writeAsBytes(await pdf.save());

        CustomSnackbar.show(
          context,
          message: 'PDF exported successfully',
          type: SnackbarType.success,
        );
      }
    } catch (e) {
      CustomSnackbar.show(
        context,
        message: 'Error exporting PDF. Please try again.',
        type: SnackbarType.error,
      );
    }
  }

  Future<void> _exportToExcel() async {
    try {
      var excel = Excel.createExcel();

      excel.delete('Sheet1');

      Sheet summarySheet = excel['Summary'];
      _populateSummarySheet(summarySheet);

      Sheet dataSheet = excel['Detailed Data'];
      _populateDataSheet(dataSheet);

      String? outputPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Excel Report',
        fileName:
            'careconnect_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.xlsx',
      );

      if (outputPath != null) {
        final file = File(outputPath);
        await file.writeAsBytes(excel.save()!);

        CustomSnackbar.show(
          context,
          message: 'Excel file exported successfully',
          type: SnackbarType.success,
        );
      }
    } catch (e) {
      CustomSnackbar.show(
        context,
        message: 'Error exporting Excel. Please try again.',
        type: SnackbarType.error,
      );
    }
  }

  void _populateSummarySheet(Sheet sheet) {
    // Headers
    sheet.cell(CellIndex.indexByString("A1")).value = TextCellValue(
      "CareConnect - Report Summary",
    );
    sheet.cell(CellIndex.indexByString("A2")).value = TextCellValue(
      "Period: ${DateFormat('dd MMM, yyyy').format(startDate)} - ${DateFormat('dd MMM, yyyy').format(endDate)}",
    );
    sheet.cell(CellIndex.indexByString("A3")).value = TextCellValue(
      "Generated: ${DateFormat('dd MMM, yyyy HH:mm').format(DateTime.now())}",
    );

    // KPI Data
    sheet.cell(CellIndex.indexByString("A5")).value = TextCellValue(
      "Key Performance Indicators",
    );
    sheet.cell(CellIndex.indexByString("A7")).value = TextCellValue("Metric");
    sheet.cell(CellIndex.indexByString("B7")).value = TextCellValue("Total");
    sheet.cell(CellIndex.indexByString("C7")).value = TextCellValue("Change %");

    sheet.cell(CellIndex.indexByString("A8")).value = TextCellValue(
      "New Clients",
    );
    sheet.cell(CellIndex.indexByString("B8")).value = IntCellValue(
      kpiData?.totalNewClients ?? 0,
    );
    sheet.cell(CellIndex.indexByString("C8")).value = TextCellValue(
      "${kpiData?.newClientsChange.toStringAsFixed(1) ?? '0.0'}%",
    );

    sheet.cell(CellIndex.indexByString("A9")).value = TextCellValue(
      "Appointments",
    );
    sheet.cell(CellIndex.indexByString("B9")).value = IntCellValue(
      kpiData?.totalAppointments ?? 0,
    );
    sheet.cell(CellIndex.indexByString("C9")).value = TextCellValue(
      "${kpiData?.appointmentsChange.toStringAsFixed(1) ?? '0.0'}%",
    );

    sheet.cell(CellIndex.indexByString("A10")).value = TextCellValue(
      "Workshops",
    );
    sheet.cell(CellIndex.indexByString("B10")).value = IntCellValue(
      kpiData?.totalWorkshops ?? 0,
    );
    sheet.cell(CellIndex.indexByString("C10")).value = TextCellValue(
      "${kpiData?.workshopsChange.toStringAsFixed(1) ?? '0.0'}%",
    );

    // Key Insight
    sheet.cell(CellIndex.indexByString("A12")).value = TextCellValue(
      "Key Insight:",
    );
    sheet.cell(CellIndex.indexByString("A13")).value = TextCellValue(
      highlightInsight,
    );
  }

  void _populateDataSheet(Sheet sheet) {
    // Headers
    sheet.cell(CellIndex.indexByString("A1")).value = TextCellValue("Date");
    sheet.cell(CellIndex.indexByString("B1")).value = TextCellValue(
      "New Clients",
    );
    sheet.cell(CellIndex.indexByString("C1")).value = TextCellValue(
      "Appointments",
    );
    sheet.cell(CellIndex.indexByString("D1")).value = TextCellValue(
      "Workshops",
    );
    sheet.cell(CellIndex.indexByString("E1")).value = TextCellValue("Total");

    // Data
    for (int i = 0; i < reportData.length; i++) {
      int row = i + 2;
      int total =
          reportData[i].newClients +
          reportData[i].appointments +
          reportData[i].workshops;

      sheet.cell(CellIndex.indexByString("A$row")).value = TextCellValue(
        DateFormat('dd-MM-yyyy').format(reportData[i].date),
      );
      sheet.cell(CellIndex.indexByString("B$row")).value = IntCellValue(
        reportData[i].newClients,
      );
      sheet.cell(CellIndex.indexByString("C$row")).value = IntCellValue(
        reportData[i].appointments,
      );
      sheet.cell(CellIndex.indexByString("D$row")).value = IntCellValue(
        reportData[i].workshops,
      );
      sheet.cell(CellIndex.indexByString("E$row")).value = IntCellValue(total);
    }

    // Summary row
    int summaryRow = reportData.length + 3;
    sheet.cell(CellIndex.indexByString("A$summaryRow")).value = TextCellValue(
      "TOTAL",
    );
    sheet.cell(CellIndex.indexByString("B$summaryRow")).value = IntCellValue(
      kpiData?.totalNewClients ?? 0,
    );
    sheet.cell(CellIndex.indexByString("C$summaryRow")).value = IntCellValue(
      kpiData?.totalAppointments ?? 0,
    );
    sheet.cell(CellIndex.indexByString("D$summaryRow")).value = IntCellValue(
      kpiData?.totalWorkshops ?? 0,
    );
    sheet.cell(CellIndex.indexByString("E$summaryRow")).value = IntCellValue(
      (kpiData?.totalNewClients ?? 0) +
          (kpiData?.totalAppointments ?? 0) +
          (kpiData?.totalWorkshops ?? 0),
    );
  }
}
