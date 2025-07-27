import 'package:careconnect_admin/layouts/master_screen.dart';
import 'package:careconnect_admin/models/responses/clients_child.dart';
import 'package:careconnect_admin/models/responses/clients_child_statistics.dart';
import 'package:careconnect_admin/models/search_objects/child_search_object.dart';
import 'package:careconnect_admin/models/search_objects/client_additional_data.dart';
import 'package:careconnect_admin/models/search_objects/client_search_object.dart';
import 'package:careconnect_admin/models/responses/search_result.dart';
import 'package:careconnect_admin/models/search_objects/clients_child_additional_data.dart';
import 'package:careconnect_admin/models/search_objects/clients_child_search_object.dart';
import 'package:careconnect_admin/providers/client_provider.dart';
import 'package:careconnect_admin/providers/clients_child_provider.dart';
import 'package:careconnect_admin/screens/client_details_screen.dart';
import 'package:careconnect_admin/theme/app_colors.dart';
import 'package:careconnect_admin/widgets/custom_dropdown_fliter.dart';
import 'package:careconnect_admin/widgets/primary_button.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ClientListScreen extends StatefulWidget {
  const ClientListScreen({super.key});

  @override
  State<ClientListScreen> createState() => _ClientListScreenState();
}

class _ClientListScreenState extends State<ClientListScreen> {
  late ClientProvider clientProvider;
  late ClientsChildProvider clientsChildProvider;

  SearchResult<ClientsChild>? result;
  int currentPage = 0;

  final TextEditingController _ftsController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String? _sortBy;
  bool _sortAscending = true;

  int? totalClients;
  int? currentlyActive;
  int? newThisMonth;

  bool? employed;

  String? selectedEmploymentStatusOption;

  final Map<String, String?> employmentStatusOptions = {
    'All Status': null,
    'Employed': 'true',
    'Not Employed': 'false',
  };

  String? selectedGenderOption;

  final Map<String, String?> genderOptions = {
    'All': null,
    'Male': 'M',
    'Female': 'F',
  };

  String? gender;

  String? selectedAgeGroupOption;
  DateTime? birthDateGTE;
  DateTime? birthDateLTE;

  final Map<String, String?> ageGroupOptions = {
    'All': null,
    '0-3': '0-3',
    '3-6': '3-6',
    '7+': '7+',
  };

  void _setBirthDateRangeFromAgeGroup(String? ageGroup) {
    final now = DateTime.now();

    if (ageGroup == '0-3') {
      birthDateLTE = now;
      birthDateGTE = DateTime(now.year - 3, now.month, now.day);
    } else if (ageGroup == '3-6') {
      birthDateLTE = DateTime(now.year - 3, now.month, now.day);
      birthDateGTE = DateTime(now.year - 6, now.month, now.day);
    } else if (ageGroup == '7+') {
      birthDateLTE = DateTime(now.year - 7, now.month, now.day);
      birthDateGTE = null;
    } else {
      birthDateGTE = null;
      birthDateLTE = null;
    }
  }

  String? selectedSortingOption;

  final Map<String, String?> sortingOptions = {
    'Not sorted': null,
    'Clients First Name': 'clientFirstName',
    'Clients Last Name': 'clientLastName',
    'Childs First Name': 'childFirstName',
    'Childs Last Name': 'childLastName',
    'Child Birth Date': 'childBirthDate',
  };

  ClientsChildStatistics? statistics;

  int maleCount = 0;
  int femaleCount = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    clientProvider = context.read<ClientProvider>();
    clientsChildProvider = context.read<ClientsChildProvider>();
  }

  @override
  void initState() {
    super.initState();

    clientProvider = context.read<ClientProvider>();
    clientsChildProvider = context.read<ClientsChildProvider>();

    loadData();

    if (clientsChildProvider.shouldRefresh) {
      loadData();
      clientsChildProvider.markRefreshed();
    }
  }

  Future<SearchResult<ClientsChild>?> loadData({int page = 0}) async {
    final clientFilterObject = ClientSearchObject(
      fts: _ftsController.text,
      firstNameGTE: _firstNameController.text,
      lastNameGTE: _lastNameController.text,
      email: _emailController.text,
      employmentStatus: employed,
      page: page,
      sortBy: _sortBy,
      sortAscending: _sortAscending,
      additionalData: ClientAdditionalData(isUserIncluded: true),
      includeTotalCount: true,
    );

    final childFilterObject = ChildSearchObject(
      fts: _ftsController.text,
      firstNameGTE: _firstNameController.text,
      lastNameGTE: _lastNameController.text,
      birthDateGTE: birthDateGTE,
      birthDateLTE: birthDateLTE,
      gender: gender,
      page: page,
      sortBy: _sortBy,
      sortAscending: _sortAscending,
      includeTotalCount: true,
    );

    final filterObject = ClientsChildSearchObject(
      clientSearchObject: clientFilterObject,
      childSearchObject: childFilterObject,
      fts: _ftsController.text,
      includeTotalCount: true,
      page: page,
      sortAscending: _sortAscending,
      sortBy: _sortBy,
      additionalData: ClientsChildAdditionalData(
        isChildIncluded: true,
        isClientIncluded: true,
      ),
    );

    final filter = filterObject.toJson();

    final newReult = await clientsChildProvider.get(filter: filter);

    result = newReult;

    final stats = await clientsChildProvider.getStatistics();

    statistics = stats;

    if (statistics?.childrenPerGender != null) {
      for (var genderGroup in statistics!.childrenPerGender) {
        if (genderGroup.gender.toLowerCase() == 'm') {
          maleCount = genderGroup.number;
        } else if (genderGroup.gender.toLowerCase() == 'f') {
          femaleCount = genderGroup.number;
        }
      }
    }

    if (mounted) {
      setState(() {});
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      "Clients",
      // SingleChildScrollView(
      //   padding: const EdgeInsets.all(16),
      //child:
      Column(
        children: [
          _buildOverview(),
          _buildSearch(),
          Consumer<ClientsChildProvider>(
            builder: (context, provider, child) {
              if (clientsChildProvider.shouldRefresh) {
                loadData();
                clientsChildProvider.markRefreshed();
              }
              return _buildResultView(result, loadData);
            },
          ),
        ],
      ),
      button: SizedBox(
        child: Align(
          alignment: Alignment.topRight,
          child: PrimaryButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClientDetailsScreen(clientsChild: null),
                ),
              );
            },
            label: 'Add Client',
            icon: Icons.person_add_alt_1,
          ),
        ),
      ),
      // ),
    );
  }

  Widget _buildOverview() {
    return Row(
      children: [
        Column(
          children: [
            Row(
              children: [
                _buildStatCard(
                  'Total Parents',
                  statistics?.totalParents,
                  Icons.groups,
                  Colors.teal,
                ),
                SizedBox(width: 20),
                _buildStatCard(
                  'Total Children',
                  statistics?.totalChildren,
                  Icons.groups,
                  Colors.teal,
                ),
              ],
            ),
            Row(
              children: [
                _buildStatCard(
                  "Employed Parents",
                  statistics?.employedParents,
                  Icons.work,
                  Colors.orange,
                ),
                SizedBox(width: 20),
                _buildStatCard(
                  "New Clients (${DateFormat.MMMM().format(DateTime.now())} ${DateTime.now().year})",
                  statistics?.newClientsThisMonth,
                  Icons.trending_up,
                  Colors.green,
                ),
              ],
            ),
          ],
        ),
        SizedBox(width: 20),
        SizedBox(
          height: 220,
          width: 280,
          child: Row(
            children: [
              Expanded(
                child: _buildChartCard(
                  title: 'Children per Age Groups',
                  chart:
                      statistics != null &&
                          statistics!.childrenPerAgeGroup.isNotEmpty
                      ? _buildChildrenPerAgeGroupBarChart()
                      : buildShimmerBarChartPlaceholder(),
                ),
              ),
            ],
          ),
        ),

        SizedBox(width: 20),
        SizedBox(
          height: 220,
          width: 280,
          child: _buildChartCard(
            title: 'Children Per Gender',
            chart:
                statistics != null && statistics!.childrenPerGender.isNotEmpty
                ? _buildChildrenPerGenderPieChart(maleCount, femaleCount)
                : buildShimmerBarChartPlaceholder(),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    dynamic value,
    IconData icon,
    Color iconColor,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1.5,
      color: AppColors.lightGray,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 400),
        child: Container(
          height: 100,
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withAlpha((0.1 * 255).toInt()),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 25),
              ),
              SizedBox(width: 16),
              // Text info
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$value',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    label,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerBar({required double height}) {
    return Column(
      children: [
        Container(
          height: 16,
          width: 20,
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 8),
        ),
        Container(width: 20, height: height, color: Colors.white),
        Container(
          height: 16,
          width: 30,
          margin: const EdgeInsets.only(top: 8),
          color: Colors.white,
        ),
      ],
    );
  }

  Widget buildShimmerBarChartPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Naslov
            Container(
              height: 20,
              width: 120,
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 24),
            ),
            // "Stubci" grafa
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildShimmerBar(height: 60),
                _buildShimmerBar(height: 40),
                _buildShimmerBar(height: 100),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard({required String title, required Widget chart}) {
    return Card(
      color: AppColors.lightGray,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepMauve,
                ),
              ),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth.isFinite
                    ? constraints.maxWidth
                    : 300.0;
                return SizedBox(height: 150, width: width, child: chart);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChildrenPerAgeGroupBarChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        barGroups: statistics!.childrenPerAgeGroup
            .asMap()
            .entries
            .map<BarChartGroupData>((entry) {
              final index = entry.key;
              final age = entry.value;
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: age.number.toDouble(),
                    color: AppColors.deepMauve,
                    width: 20,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              );
            })
            .toList(),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                int index = value.toInt();
                if (index < statistics!.childrenPerAgeGroup.length) {
                  final category =
                      statistics!.childrenPerAgeGroup[index].category;
                  return SideTitleWidget(
                    meta: meta,
                    space: 8,
                    child: Text(category, style: const TextStyle(fontSize: 10)),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                int index = value.toInt();
                if (index < statistics!.childrenPerAgeGroup.length) {
                  final number = statistics!.childrenPerAgeGroup[index].number
                      .toString();
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(number, style: const TextStyle(fontSize: 10)),
                    space: 8,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
      ),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOut,
    );
  }

  Widget _buildChildrenPerGenderPieChart(int maleCount, int femaleCount) {
    return Column(
      children: [
        Expanded(child: buildGenderPieChartChartOnly(maleCount, femaleCount)),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegend(AppColors.dustyRose, "Male"),
            const SizedBox(width: 16),
            _buildLegend(AppColors.deepMauve, "Female"),
          ],
        ),
      ],
    );
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      children: [
        Container(width: 12, height: 12, color: color),
        SizedBox(width: 4),
        Text(label),
      ],
    );
  }

  Widget buildGenderPieChartChartOnly(int maleCount, int femaleCount) {
    final total = maleCount + femaleCount;
    if (total == 0) {
      return const Center(child: Text('No gender data'));
    }

    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            color: AppColors.dustyRose,
            value: maleCount.toDouble(),
            title: '${(maleCount / total * 100).toStringAsFixed(1)}%',
          ),
          PieChartSectionData(
            color: AppColors.deepMauve,
            value: femaleCount.toDouble(),
            title: '${(femaleCount / total * 100).toStringAsFixed(1)}%',
          ),
        ],
        sectionsSpace: 2,
        centerSpaceRadius: 0,
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            // Search
            Expanded(
              child: TextField(
                controller: _ftsController,
                decoration: InputDecoration(
                  labelText: "Search First Name, Last Name and Email",
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
                onChanged: (value) => loadData(),
              ),
            ),
            SizedBox(width: 8),
            // Employment Status
            Container(
              width: 270,
              child: CustomDropdownFliter(
                selectedValue: selectedEmploymentStatusOption,
                options: employmentStatusOptions,
                name: "Employment Status: ",
                onChanged: (newStatus) {
                  setState(() {
                    selectedEmploymentStatusOption = newStatus;
                    if (newStatus == 'true') {
                      employed = true;
                    } else if (newStatus == 'false') {
                      employed = false;
                    } else {
                      employed = null;
                    }
                  });
                  loadData();
                },
              ),
            ),
            SizedBox(width: 8),
            // Employment Status
            Container(
              width: 200,
              child: CustomDropdownFliter(
                selectedValue: selectedGenderOption,
                options: genderOptions,
                name: "Child Gender: ",
                onChanged: (newGender) {
                  setState(() {
                    selectedGenderOption = newGender;
                    gender = newGender;
                  });
                  loadData();
                },
              ),
            ),
            SizedBox(width: 8),
            // Employment Status
            Container(
              width: 150,
              child: CustomDropdownFliter(
                selectedValue: selectedAgeGroupOption,
                options: ageGroupOptions,
                name: "Child Age: ",
                onChanged: (value) {
                  setState(() {
                    selectedAgeGroupOption = value;
                    _setBirthDateRangeFromAgeGroup(value);
                    loadData();
                  });
                },
              ),
            ),
            SizedBox(width: 8),
            // Sort by
            Container(
              width: 200,
              child: CustomDropdownFliter(
                selectedValue: selectedSortingOption,
                options: sortingOptions,
                name: "Sort by: ",
                onChanged: (newStatus) {
                  setState(() {
                    selectedSortingOption = newStatus;
                    _sortBy = newStatus;
                  });
                  loadData();
                },
              ),
            ),
            SizedBox(width: 8),
            // Asc/Desc toggle
            IconButton(
              icon: Icon(
                _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                color: Colors.black,
              ),
              tooltip: _sortAscending ? 'Ascending' : 'Descending',
              onPressed: () {
                setState(() {
                  _sortAscending = !_sortAscending;
                });
                loadData();
              },
            ),
            SizedBox(width: 8),
            // Refresh
            TextButton.icon(
              onPressed: () async {
                _ftsController.clear();
                _sortBy = null;
                employed = null;
                selectedAgeGroupOption = null;
                selectedEmploymentStatusOption = null;
                selectedGenderOption = null;
                selectedSortingOption = null;
                gender = null;
                birthDateGTE = null;
                birthDateLTE = null;
                loadData();
              },
              label: Text("Refresh", style: TextStyle(color: Colors.black)),
              icon: Icon(Icons.refresh_outlined, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultView(
    SearchResult<ClientsChild>? result,
    Future<SearchResult<ClientsChild>?> Function({int page}) loadData,
  ) {
    if (result != null) {
      return Expanded(
        child: ClientsChildTable(result: result, onPageChanged: loadData),
      );
    } else {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('No data available.'),
      );
    }
  }
}

class ClientsChildTable extends StatefulWidget {
  final SearchResult<ClientsChild>? result;
  final Future<SearchResult<ClientsChild>?> Function({int page}) onPageChanged;

  const ClientsChildTable({
    super.key,
    this.result,
    required this.onPageChanged,
  });

  @override
  State<ClientsChildTable> createState() => _ClientsChildTableState();
}

class _ClientsChildTableState extends State<ClientsChildTable> {
  final int _pageSize = 10;
  int _currentPage = 0;
  bool _isLoading = false;
  ClientsChildDataSource? _dataSource;

  @override
  void initState() {
    super.initState();
    _updateDataSource();
  }

  @override
  void didUpdateWidget(ClientsChildTable oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.result != widget.result) {
      _updateDataSource();
    }
  }

  void _updateDataSource() {
    final clientsChild = widget.result?.result ?? [];
    final totalCount = widget.result?.totalCount ?? 0;

    _dataSource = ClientsChildDataSource(
      clientsChild,
      context,
      totalCount,
      onPageChanged: _fetchPage,
      pageSize: _pageSize,
      currentPage: _currentPage,
    );
  }

  Future<void> _fetchPage(int page) async {
    if (_isLoading || page == _currentPage) return;

    setState(() {
      _isLoading = true;
      _currentPage = page;
    });

    try {
      await widget.onPageChanged(page: page);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _currentPage = _currentPage > 0 ? _currentPage - 1 : 0;
        });
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading data: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final clientsChild = widget.result?.result ?? [];
    //final totalCount = widget.result?.totalCount ?? 0;

    if (_isLoading && clientsChild.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_dataSource == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        PaginatedDataTable2(
          key: ValueKey('${widget.result?.result.hashCode}_$_currentPage'),

          columns: const [
            DataColumn2(label: Text('Employee Name')),
            DataColumn2(label: Text('Child Name')),
            DataColumn2(label: Text('Child Gender')),
            DataColumn2(label: Text('Child Age')),
            DataColumn2(label: Text('Phone Number')),
            DataColumn2(label: Text('Email')),
            DataColumn2(
              label: Center(child: Text('Actions')),
              size: ColumnSize.S,
              fixedWidth: 120,
            ),
          ],
          source: _dataSource!,
          rowsPerPage: _pageSize,
          onPageChanged: (start) {
            final newPage = start ~/ _pageSize;
            if (newPage != _currentPage && !_isLoading) {
              _fetchPage(newPage);
            }
          },
          initialFirstRowIndex: _currentPage * _pageSize,
          columnSpacing: 15,
          horizontalMargin: 12,
          minWidth: 600,
          showCheckboxColumn: false,
          availableRowsPerPage: const [10],
        ),
        if (_isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.white.withAlpha((0.7 * 255).toInt()),
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }
}

class ClientsChildDataSource extends DataTableSource {
  final List<ClientsChild> clientsChild;
  final BuildContext context;
  final int? count;
  final Future<void> Function(int page)? onPageChanged;
  final int pageSize;
  final int currentPage;

  ClientsChildDataSource(
    this.clientsChild,
    this.context,
    this.count, {
    this.onPageChanged,
    this.pageSize = 10,
    this.currentPage = 0,
  });

  @override
  DataRow? getRow(int index) {
    final requestedPage = index ~/ pageSize;

    if (requestedPage != currentPage) return null;

    final localIndex = index % pageSize;

    if (localIndex < 0 || localIndex >= clientsChild.length) return null;

    final clientChild = clientsChild[localIndex];

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Text(
            "${clientChild.client.user?.firstName ?? " "} ${clientChild.client.user?.lastName ?? ""}",
          ),
        ),
        DataCell(
          Text("${clientChild.child.firstName} ${clientChild.child.lastName}"),
        ),
        DataCell(Text(clientChild.child.gender == "M" ? "Male" : "Female")),
        DataCell(
          Text(
            (DateTime.now().year - clientChild.child.birthDate.year).toString(),
          ),
        ),
        DataCell(Text(clientChild.client.user?.phoneNumber ?? "")),
        DataCell(Text(clientChild.client.user?.email ?? "")),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: Colors.grey),
                tooltip: 'Edit',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ClientDetailsScreen(clientsChild: clientChild),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline_outlined,
                  color: Colors.grey,
                ),
                tooltip: 'Delete',
                onPressed: () {
                  // Handle delete
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => count ?? clientsChild.length;

  @override
  int get selectedRowCount => 0;

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
