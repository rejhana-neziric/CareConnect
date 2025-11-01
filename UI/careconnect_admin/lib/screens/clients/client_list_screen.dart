import 'package:careconnect_admin/core/layouts/master_screen.dart';
import 'package:careconnect_admin/models/responses/clients_child.dart';
import 'package:careconnect_admin/models/responses/clients_child_statistics.dart';
import 'package:careconnect_admin/models/responses/search_result.dart';
import 'package:careconnect_admin/providers/client_provider.dart';
import 'package:careconnect_admin/providers/clients_child_form_provider.dart';
import 'package:careconnect_admin/providers/clients_child_provider.dart';
import 'package:careconnect_admin/providers/permission_provider.dart';
import 'package:careconnect_admin/screens/clients/child_details_screen.dart';
import 'package:careconnect_admin/screens/clients/client_details_screen.dart';
import 'package:careconnect_admin/core/theme/app_colors.dart';
import 'package:careconnect_admin/screens/no_permission_screen.dart';
import 'package:careconnect_admin/widgets/custom_dropdown_fliter.dart';
import 'package:careconnect_admin/widgets/no_results.dart';
import 'package:careconnect_admin/widgets/primary_button.dart';
import 'package:careconnect_admin/widgets/shimmer_stat_card.dart';
import 'package:careconnect_admin/widgets/snackbar.dart';
import 'package:careconnect_admin/widgets/stat_card.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ClientListScreen extends StatefulWidget {
  const ClientListScreen({super.key});

  @override
  State<ClientListScreen> createState() => _ClientListScreenState();
}

class _ClientListScreenState extends State<ClientListScreen> {
  late ClientProvider clientProvider;
  late ClientsChildProvider clientsChildProvider;
  late PermissionProvider permissionProvider;

  SearchResult<ClientsChild>? result;
  int currentPage = 0;

  bool isLoading = false;

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

  bool isHoveredParent = false;
  bool isHoveredChild = false;

  final GlobalKey<_ClientsChildTableState> tableKey = GlobalKey();

  void _reloadTable() {
    tableKey.currentState?.reloadTable();
  }

  void _reloadCurrentPageTable() {
    tableKey.currentState?.refreshCurrentPage();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    clientProvider = context.read<ClientProvider>();
    clientsChildProvider = context.read<ClientsChildProvider>();

    permissionProvider = Provider.of<PermissionProvider>(
      context,
      listen: false,
    );

    loadData();
  }

  Future<void> loadData({int page = 0}) async {
    setState(() {
      isLoading = true;
    });

    try {
      tableKey.currentState?.currentPage = 0;

      final clientsChildProvider = Provider.of<ClientsChildProvider>(
        context,
        listen: false,
      );

      final finalResult = await clientsChildProvider.loadData(
        fts: _ftsController.text,
        firstNameGTE: _firstNameController.text,
        lastNameGTE: _lastNameController.text,
        email: _emailController.text,
        employmentStatus: employed,
        birthDateGTE: birthDateGTE,
        birthDateLTE: birthDateLTE,
        gender: gender,
        page: page,
        sortBy: _sortBy,
        sortAscending: _sortAscending,
      );

      result = finalResult;

      loadStats();

      if (mounted) {
        setState(() {});
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> loadStats() async {
    final stats = await clientsChildProvider.loadStats();

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
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (!permissionProvider.canViewClientScreen()) {
      return MasterScreen(
        'Clients',
        NoPermissionScreen(),
        currentScreen: "Clients",
      );
    }

    return MasterScreen(
      "Clients",
      currentScreen: "Clients",
      Column(
        children: [
          if (permissionProvider.canViewClientsChildStatistic())
            _buildOverview(),
          _buildSearch(colorScheme),
          Consumer<ClientsChildProvider>(
            builder: (context, clientsChildProvider, child) {
              return _buildResultView(colorScheme);
            },
          ),
        ],
      ),
      button: permissionProvider.canInsertClient()
          ? SizedBox(
              child: Align(
                alignment: Alignment.topRight,
                child: PrimaryButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                          create: (_) => ClientsChildFormProvider(),
                          child: ClientDetailsScreen(clientsChild: null),
                        ),
                      ),
                    );

                    if (result == true) loadData();
                  },
                  label: 'Add Client',
                  icon: Icons.person_add_alt_1,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildOverview() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    isLoading || statistics?.totalParents == null
                        ? shimmerStatCard(context)
                        : statCard(
                            context,
                            'Total Parents',
                            statistics?.totalParents,
                            Icons.groups,
                            Colors.teal,
                          ),
                    SizedBox(width: 20),
                    isLoading || statistics?.totalChildren == null
                        ? shimmerStatCard(context)
                        : statCard(
                            context,
                            'Total Children',
                            statistics?.totalChildren,
                            Icons.groups,
                            Colors.teal,
                          ),
                  ],
                ),
                Row(
                  children: [
                    isLoading || statistics?.employedParents == null
                        ? shimmerStatCard(context)
                        : statCard(
                            context,
                            "Employed Parents",
                            statistics?.employedParents,
                            Icons.work,
                            Colors.orange,
                          ),
                    SizedBox(width: 20),
                    isLoading || statistics?.newClientsThisMonth == null
                        ? shimmerStatCard(context)
                        : statCard(
                            context,
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
                      context: context,
                      title: 'Children per Age Groups',
                      chart:
                          statistics != null &&
                              statistics!.childrenPerAgeGroup.isNotEmpty
                          ? _buildChildrenPerAgeGroupBarChart()
                          : shimmerStatCard(
                              context,
                              width: 280,
                            ), //shimmerBarChartPlaceholder(context),
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
                context: context,
                title: 'Children Per Gender',
                chart:
                    statistics != null &&
                        statistics!.childrenPerGender.isNotEmpty
                    ? _buildChildrenPerGenderPieChart(maleCount, femaleCount)
                    : shimmerStatCard(
                        context,
                        width: 280,
                      ), //shimmerBarChartPlaceholder(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard({
    required BuildContext context,
    required String title,
    required Widget chart,
  }) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
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

  Widget _buildSearch(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
          color: colorScheme.surfaceContainerLowest,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 500,
                child: TextField(
                  controller: _ftsController,
                  decoration: InputDecoration(
                    labelText: "Search First Name, Last Name and Email",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                    fillColor: colorScheme.surfaceContainerLowest,
                    filled: true,
                  ),
                  onChanged: (value) => loadData(),
                ),
              ),
              SizedBox(width: 8),
              // Employment Status
              Container(
                width: 270,
                child: CustomDropdownFilter(
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
              SizedBox(
                width: 200,
                child: CustomDropdownFilter(
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
              SizedBox(
                width: 150,
                child: CustomDropdownFilter(
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
              SizedBox(
                width: 200,
                child: CustomDropdownFilter(
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
                  color: colorScheme.onPrimaryContainer,
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
                  if (_ftsController.text.isEmpty == false ||
                      _sortBy != null ||
                      employed != null ||
                      selectedAgeGroupOption != null ||
                      selectedEmploymentStatusOption != null ||
                      selectedGenderOption != null ||
                      selectedSortingOption != null ||
                      gender != null ||
                      birthDateGTE != null ||
                      birthDateLTE != null) {
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
                    loadData(page: 0);
                    _reloadTable();
                  } else {
                    loadData(page: 0);
                    _reloadCurrentPageTable();
                  }
                },
                label: Text(
                  "Refresh",
                  style: TextStyle(color: colorScheme.onPrimaryContainer),
                ),
                icon: Icon(
                  Icons.refresh_outlined,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultView(ColorScheme colorScheme) {
    if (isLoading && (result == null || result!.result.isEmpty)) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }

    return (result != null && result?.result.isEmpty == false)
        ? Expanded(
            child: ClientsChildTable(
              key: tableKey,
              result: result,
              onPageChanged: loadData,
              colorScheme: colorScheme,
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(128.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NoResultsWidget(message: 'No results found. Please try again.'),
              ],
            ),
          );
  }
}

class ClientsChildTable extends StatefulWidget {
  final SearchResult<ClientsChild>? result;
  final Future<void> Function({int page}) onPageChanged;
  final ColorScheme colorScheme;

  const ClientsChildTable({
    super.key,
    this.result,
    required this.onPageChanged,
    required this.colorScheme,
  });

  @override
  State<ClientsChildTable> createState() => _ClientsChildTableState();
}

class _ClientsChildTableState extends State<ClientsChildTable> {
  final int _pageSize = 10;
  int currentPage = 0;
  bool isLoading = false;
  ClientsChildDataSource? _dataSource;

  bool isHoveredParent = false;
  bool isHoveredChild = false;

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

    final permissionProvider = Provider.of<PermissionProvider>(
      context,
      listen: false,
    );

    final canViewClientDetails = permissionProvider.canViewClientDetails();
    final canViewChildDetails = permissionProvider.canViewChildDetails();

    _dataSource = ClientsChildDataSource(
      clientsChild,
      context,
      widget.colorScheme,
      totalCount,
      onPageChanged: _fetchPage,
      pageSize: _pageSize,
      currentPage: currentPage,
      canViewClientDetails: canViewClientDetails,
      canViewChildDetails: canViewChildDetails,
    );
  }

  void refreshCurrentPage() {
    _fetchPage(currentPage);
  }

  void reloadTable() {
    _fetchPage(0);
  }

  Future<void> _fetchPage(int page) async {
    setState(() {
      isLoading = true;
      currentPage = page;
    });

    try {
      await widget.onPageChanged(page: page);

      if (mounted) {
        setState(() {
          currentPage = page;
          _updateDataSource();
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          currentPage = currentPage > 0 ? currentPage - 1 : 0;
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

    if (isLoading && clientsChild.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_dataSource == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        PaginatedDataTable2(
          key: ValueKey('${widget.result?.result.hashCode}_$currentPage'),
          wrapInCard: false,
          renderEmptyRowsInTheEnd: false,
          columns: const [
            DataColumn2(label: Text('Parent Name')),
            DataColumn2(label: Text('Child Name')),
            DataColumn2(label: Text('Child Gender')),
            DataColumn2(label: Text('Child Age')),
            DataColumn2(label: Text('Phone Number')),
            DataColumn2(label: Text('Email')),
            DataColumn2(
              label: Text('Actions'),
              size: ColumnSize.S,
              fixedWidth: 80,
            ),
          ],
          source: _dataSource!,
          rowsPerPage: _pageSize,
          onPageChanged: (start) {
            final newPage = start ~/ _pageSize;
            if (newPage != currentPage && !isLoading) {
              _fetchPage(newPage);
            }
          },
          initialFirstRowIndex: currentPage * _pageSize,
          columnSpacing: 15,
          horizontalMargin: 12,
          minWidth: 600,
          showCheckboxColumn: false,
          availableRowsPerPage: const [10],
        ),
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.transparent,
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
  final ColorScheme colorScheme;
  final bool canViewClientDetails;
  final bool canViewChildDetails;

  ClientsChildDataSource(
    this.clientsChild,
    this.context,
    this.colorScheme,
    this.count, {
    this.onPageChanged,
    this.pageSize = 10,
    this.currentPage = 0,
    required this.canViewClientDetails,
    required this.canViewChildDetails,
  });

  final ValueNotifier<int?> hoveredRowNotifier = ValueNotifier(null);

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
          MouseRegion(
            onEnter: (_) => hoveredRowNotifier.value = index,
            onExit: (_) => hoveredRowNotifier.value = null,
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                      create: (_) => ClientsChildFormProvider(),
                      child: ClientDetailsScreen(clientsChild: clientChild),
                    ),
                  ),
                );

                if (result == true && onPageChanged != null) {
                  onPageChanged!(currentPage);
                }
              },
              child: ValueListenableBuilder(
                valueListenable: hoveredRowNotifier,
                builder: (context, hoveredIndex, _) {
                  final isHoveredParent = hoveredIndex == index;
                  return Text(
                    "${clientChild.client.user?.firstName ?? ""} ${clientChild.client.user?.lastName ?? ""}",
                    style: TextStyle(
                      decoration: isHoveredParent
                          ? TextDecoration.underline
                          : TextDecoration.none,
                      color: isHoveredParent
                          ? colorScheme.primary
                          : colorScheme.onPrimaryContainer,
                      shadows: isHoveredParent
                          ? [
                              Shadow(
                                color: Colors.blueAccent.withOpacity(0.4),
                                offset: Offset(0, 1.5),
                                blurRadius: 4,
                              ),
                            ]
                          : [],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        DataCell(
          MouseRegion(
            onEnter: (_) => hoveredRowNotifier.value = index,
            onExit: (_) => hoveredRowNotifier.value = null,
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                      create: (_) => ClientsChildFormProvider(),
                      child: ChildDetailsScreen(
                        client: clientChild.client,
                        child: clientChild.child,
                      ),
                    ),
                  ),
                );

                if (result == true && onPageChanged != null) {
                  onPageChanged!(currentPage);
                }
              },
              child: ValueListenableBuilder(
                valueListenable: hoveredRowNotifier,
                builder: (context, hoveredIndex, _) {
                  final isHovered = hoveredIndex == index;
                  return Text(
                    "${clientChild.child.firstName} ${clientChild.child.lastName}",
                    style: TextStyle(
                      decoration: isHovered
                          ? TextDecoration.underline
                          : TextDecoration.none,
                      color: isHovered
                          ? colorScheme.primary
                          : colorScheme.onPrimaryContainer,
                      shadows: isHovered
                          ? [
                              Shadow(
                                color: Colors.blueAccent.withOpacity(0.4),
                                offset: Offset(0, 1.5),
                                blurRadius: 4,
                              ),
                            ]
                          : [],
                    ),
                  );
                },
              ),
            ),
          ),
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
          Center(
            child: PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'client') {
                  if (!canViewClientDetails) {
                    CustomSnackbar.show(
                      context,
                      message:
                          'You do not have permission to perform this action.',
                      type: SnackbarType.error,
                    );
                  } else {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                          create: (_) => ClientsChildFormProvider(),
                          child: ClientDetailsScreen(clientsChild: clientChild),
                        ),
                      ),
                    );

                    if (result == true && onPageChanged != null) {
                      onPageChanged!(currentPage);
                    }
                  }
                } else if (value == 'child') {
                  if (!canViewChildDetails) {
                    CustomSnackbar.show(
                      context,
                      message:
                          'You do not have permission to perform this action.',
                      type: SnackbarType.error,
                    );
                  } else {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                          create: (_) => ClientsChildFormProvider(),
                          child: ChildDetailsScreen(
                            client: clientChild.client,
                            child: clientChild.child,
                          ),
                        ),
                      ),
                    );

                    if (result == true && onPageChanged != null) {
                      onPageChanged!(currentPage);
                    }
                  }
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'client',
                  child: Text('View client details'),
                ),
                const PopupMenuItem(
                  value: 'child',
                  child: Text('View child details'),
                ),
              ],
              child: const Icon(Icons.more_vert),
            ),
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
