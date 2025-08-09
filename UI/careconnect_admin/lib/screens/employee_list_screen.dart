import 'package:careconnect_admin/layouts/master_screen.dart';
import 'package:careconnect_admin/models/responses/employee.dart';
import 'package:careconnect_admin/models/search_objects/employee_additional_data.dart';
import 'package:careconnect_admin/models/search_objects/employee_search_object.dart';
import 'package:careconnect_admin/models/responses/search_result.dart';
import 'package:careconnect_admin/providers/employee_provider.dart';
import 'package:careconnect_admin/screens/employee_details_screen.dart';
import 'package:careconnect_admin/theme/app_colors.dart';
import 'package:careconnect_admin/widgets/custom_dropdown_fliter.dart';
import 'package:careconnect_admin/widgets/primary_button.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  late EmployeeProvider provider;

  SearchResult<Employee>? result;
  int currentPage = 0;

  final TextEditingController _ftsController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();

  String? _sortBy;
  bool _sortAscending = true;

  int? totalEmployees;
  int? currentlyEmployeed;
  int? newThisMonth;

  DateTime? _from;
  DateTime? _to;

  final GlobalKey<_HireDateRangePickerState> _pickerKey = GlobalKey();

  bool? employed;

  String? selectedSortingOption;

  final Map<String, String?> sortingOptions = {
    'Not sorted': null,
    'First Name': 'firstName',
    'Last Name': 'lastName',
    'Job Title': 'jobTitle',
  };

  String? selectedEmploymentStatusOption;

  final Map<String, String?> employmentStatusOptions = {
    'All Status': null,
    'Employed': 'true',
    'Not Employed': 'false',
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    provider = context.read<EmployeeProvider>();
  }

  @override
  void initState() {
    super.initState();
    provider = context.read<EmployeeProvider>();
    loadData();

    if (provider.shouldRefresh) {
      loadData();
      provider.markRefreshed();
    }
  }

  Future<SearchResult<Employee>?> loadData({int page = 0}) async {
    final filterObject = EmployeeSearchObject(
      fts: _ftsController.text,
      firstNameGTE: _firstNameController.text,
      lastNameGTE: _lastNameController.text,
      email: _emailController.text,
      jobTitle: _jobTitleController.text,
      hireDateGTE: _from,
      hireDateLTE: _to,
      employed: employed,
      page: page,
      sortBy: _sortBy,
      sortAscending: _sortAscending,
      additionalData: EmployeeAdditionalData(
        isUserIncluded: true,
        isQualificationIncluded: true,
      ),
      includeTotalCount: true,
    );

    final filter = filterObject.toJson();

    final newResult = await provider.get(filter: filter);

    result = newResult;

    final statistics = await provider.getStatistics();

    totalEmployees = statistics['totalEmployees'];
    currentlyEmployeed = statistics['currentlyEmployed'];
    newThisMonth = statistics['employedThisMonth'];

    if (mounted) {
      setState(() {});
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      "Employees",
      // SingleChildScrollView(
      //   padding: const EdgeInsets.all(16), // optional for spacing
      //   child:
      Column(
        children: [
          _buildOverview(),
          _buildSearch(),
          Consumer<EmployeeProvider>(
            builder: (context, provider, child) {
              if (provider.shouldRefresh) {
                loadData();
                provider.markRefreshed();
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
                  builder: (context) => EmployeeDetailsScreen(employee: null),
                ),
              );
            },
            label: 'Add Employee',
            icon: Icons.person_add_alt_1,
          ),
        ),
      ),
      // ),
    );
  }

  Widget _buildOverview() {
    return Column(
      children: [
        // SizedBox(
        //   child: Align(
        //     alignment: Alignment.topRight,
        //     child: PrimaryButton(
        //       onPressed: () {
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //             builder: (context) => EmployeeDetailsScreen(employee: null),
        //           ),
        //         );
        //       },
        //       label: 'Add Employee',
        //       icon: Icons.person_add_alt_1,
        //     ),
        //   ),
        // ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatCard(
              'Total Employees',
              totalEmployees,
              Icons.groups,
              Colors.teal,
            ),
            _buildStatCard(
              'Currently Employed',
              currentlyEmployeed,
              Icons.verified_user,

              Colors.orange,
            ),
            _buildStatCard(
              'New This Month',
              newThisMonth,
              Icons.person_add,

              Colors.red,
            ),
          ],
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
              // Circle background for the icon
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

  void _applyHireDateFilter(DateTime? start, DateTime? end) {
    setState(() {
      _from = start;
      _to = end;
      loadData();
    });
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
                  labelText:
                      "Search First Name, Last Name, Email and Job Title",
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
                onChanged: (value) => loadData(),
              ),
            ),
            SizedBox(width: 8),
            // Hire Date Range
            HireDateRangePicker(
              key: _pickerKey,
              onRangeChanged: _applyHireDateFilter,
            ),
            if (_from != null || _to != null)
              TextButton(
                onPressed: () {
                  _pickerKey.currentState?.clear();
                  _applyHireDateFilter(null, null);
                }, // clear
                child: const Text('Clear'),
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
                selectedSortingOption = null;
                selectedEmploymentStatusOption = null;
                employed = null;
                _pickerKey.currentState?.clear();
                _applyHireDateFilter(null, null);
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
    SearchResult<Employee>? result,
    Future<SearchResult<Employee>?> Function({int page}) loadData,
  ) {
    if (result != null) {
      return Expanded(
        child: EmployeeTable(result: result, onPageChanged: loadData),
      );
    } else {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('No data available.'),
      );
    }
  }
}

class EmployeeTable extends StatefulWidget {
  final SearchResult<Employee>? result;
  final Future<SearchResult<Employee>?> Function({int page}) onPageChanged;

  const EmployeeTable({super.key, this.result, required this.onPageChanged});

  @override
  State<EmployeeTable> createState() => _EmployeeTableState();
}

class _EmployeeTableState extends State<EmployeeTable> {
  final int _pageSize = 10;
  int _currentPage = 0;
  bool _isLoading = false;
  EmployeeDataSource? _dataSource;

  @override
  void initState() {
    super.initState();
    _updateDataSource();
  }

  @override
  void didUpdateWidget(EmployeeTable oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.result != widget.result) {
      _updateDataSource();
    }
  }

  void _updateDataSource() {
    final employees = widget.result?.result ?? [];
    final totalCount = widget.result?.totalCount ?? 0;

    _dataSource = EmployeeDataSource(
      employees,
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
    final employees = widget.result?.result ?? [];
    //final totalCount = widget.result?.totalCount ?? 0;

    if (_isLoading && employees.isEmpty) {
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
            DataColumn2(label: Text('Job Title')),
            DataColumn2(label: Text('Email')),
            DataColumn2(label: Text('Phone Number')),
            DataColumn2(
              label: Text('Status'),
              size: ColumnSize.M,
              fixedWidth: 200,
            ),
            DataColumn2(
              label: Center(child: Text('Actions')),
              size: ColumnSize.S,
              fixedWidth: 120,
            ),
          ],
          source: _dataSource!, //ovo moze biti prazno
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

class EmployeeDataSource extends DataTableSource {
  final List<Employee> employees;
  final BuildContext context;
  final int? count;
  final Future<void> Function(int page)? onPageChanged;
  final int pageSize;
  final int currentPage;

  EmployeeDataSource(
    this.employees,
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

    if (localIndex < 0 || localIndex >= employees.length) return null;

    final employee = employees[localIndex];

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Text("${employee.user?.firstName} ${employee.user?.lastName}"),
        ),
        DataCell(Text(employee.jobTitle.toString())),
        DataCell(Text(employee.user?.email ?? " ")),
        DataCell(Text(employee.user?.phoneNumber ?? "")),
        DataCell(
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: employee.endDate == null
                  ? const Color.fromRGBO(204, 245, 215, 1)
                  : Colors.red.shade50,
              border: null, //Border.all(
              //color: employee.endDate == null ? Colors.black : Colors.red,
              //),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              employee.endDate == null ? "Employed" : "Not Employed",
              style: TextStyle(
                color: employee.endDate == null
                    ? Color.fromARGB(255, 80, 80, 80)
                    : Colors.red,

                ///fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
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
                          EmployeeDetailsScreen(employee: employee),
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
  int get rowCount => count ?? employees.length;

  @override
  int get selectedRowCount => 0;

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}

class HireDateRangePicker extends StatefulWidget {
  final void Function(DateTime? start, DateTime? end) onRangeChanged;

  const HireDateRangePicker({super.key, required this.onRangeChanged});

  @override
  State<HireDateRangePicker> createState() => _HireDateRangePickerState();
}

class _HireDateRangePickerState extends State<HireDateRangePicker> {
  DateTime? _start, _end;
  final _fmt = DateFormat('MMM dd, yyyy');

  void clear() {
    setState(() {
      _start = null;
      _end = null;
    });
  }

  void _pickRange() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hire date range'),
        content: SizedBox(
          width: 350,
          height: 400,
          child: SfDateRangePicker(
            selectionMode: DateRangePickerSelectionMode.range,
            showActionButtons: true,
            initialSelectedRange: _start != null
                ? PickerDateRange(_start, _end)
                : null,
            onSelectionChanged: (args) {
              if (args.value is PickerDateRange) {
                final r = args.value as PickerDateRange;
                setState(() {
                  _start = r.startDate;
                  _end = r.endDate;
                });
              }
            },
            onSubmit: (_) {
              widget.onRangeChanged(_start, _end);
              Navigator.pop(context);
            },
            onCancel: () => Navigator.pop(context),
          ),
        ),
      ),
    );
  }

  String get _btnLabel {
    if (_start == null || _end == null) return 'Pick hire date range';
    return '${_fmt.format(_start!)} → ${_fmt.format(_end!)}';
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: _pickRange,
      icon: const Icon(Icons.calendar_month),
      label: Text(_btnLabel),
    );
  }
}
