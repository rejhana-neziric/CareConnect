import 'package:careconnect_admin/core/layouts/master_screen.dart';
import 'package:careconnect_admin/models/responses/employee.dart';
import 'package:careconnect_admin/models/responses/search_result.dart';
import 'package:careconnect_admin/providers/employee_form_provider.dart';
import 'package:careconnect_admin/providers/employee_provider.dart';
import 'package:careconnect_admin/providers/permission_provider.dart';
import 'package:careconnect_admin/screens/employees/employee_details_screen.dart';
import 'package:careconnect_admin/screens/no_permission_screen.dart';
import 'package:careconnect_admin/widgets/confirm_dialog.dart';
import 'package:careconnect_admin/widgets/custom_dropdown_fliter.dart';
import 'package:careconnect_admin/widgets/no_results.dart';
import 'package:careconnect_admin/widgets/primary_button.dart';
import 'package:careconnect_admin/widgets/shimmer_stat_card.dart';
import 'package:careconnect_admin/widgets/snackbar.dart';
import 'package:careconnect_admin/widgets/stat_card.dart';

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
  late EmployeeProvider employeeProvider;
  late PermissionProvider permissionProvider;

  SearchResult<Employee>? employees;
  int currentPage = 0;

  bool isLoading = false;

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

  final GlobalKey<_EmployeeTableState> tableKey = GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    employeeProvider = context.read<EmployeeProvider>();
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

      final employeeProvider = Provider.of<EmployeeProvider>(
        context,
        listen: false,
      );

      final result = await employeeProvider.loadData(
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
      );

      employees = result;

      final statistics = await employeeProvider.getStatistics();

      totalEmployees = statistics['totalEmployees'];
      currentlyEmployeed = statistics['currentlyEmployed'];
      newThisMonth = statistics['employedThisMonth'];

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (!permissionProvider.canViewEmployeeScreen()) {
      return MasterScreen(
        'Employees',
        NoPermissionScreen(),
        currentScreen: "Employees",
      );
    }

    return MasterScreen(
      "Employees",
      currentScreen: "Employees",
      Column(
        children: [
          if (permissionProvider.canViewEmployeeStatistics()) _buildOverview(),
          _buildSearch(colorScheme),
          Consumer<EmployeeProvider>(
            builder: (context, employeeProvider, child) {
              return _buildResultView();
            },
          ),
        ],
      ),
      button: permissionProvider.canInsertEmployee()
          ? SizedBox(
              child: Align(
                alignment: Alignment.topRight,
                child: PrimaryButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                          create: (_) => EmployeeFormProvider(),
                          child: EmployeeDetailsScreen(employee: null),
                        ),
                      ),
                    );

                    if (result == true) loadData();
                  },
                  label: 'Add Employee',
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
            isLoading
                ? shimmerStatCard(context)
                : statCard(
                    context,
                    'Total Employees',
                    totalEmployees,
                    Icons.groups,
                    Colors.teal,
                  ),
            const SizedBox(width: 8),

            isLoading
                ? shimmerStatCard(context)
                : statCard(
                    context,
                    'Currently Employed',
                    currentlyEmployeed,
                    Icons.verified_user,
                    Colors.orange,
                  ),

            const SizedBox(width: 8),

            isLoading
                ? shimmerStatCard(context)
                : statCard(
                    context,
                    'New This Month',
                    newThisMonth,
                    Icons.person_add,
                    Colors.red,
                  ),
          ],
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

  Widget _buildSearch(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLowest,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Search field
              SizedBox(
                width: 500,
                child: TextField(
                  controller: _ftsController,
                  decoration: InputDecoration(
                    labelText:
                        "Search First Name, Last Name, Email and Job Title",

                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(
                      color: colorScheme.onPrimaryContainer,
                    ),
                    prefixIcon: Icon(Icons.search),
                    fillColor: colorScheme.surfaceContainerLowest,
                    filled: true,
                  ),
                  onChanged: (value) => loadData(),
                ),
              ),
              const SizedBox(width: 8),

              // Hire Date Range Picker
              HireDateRangePicker(
                key: _pickerKey,
                onRangeChanged: _applyHireDateFilter,
              ),

              if (_from != null || _to != null)
                TextButton(
                  onPressed: () {
                    _pickerKey.currentState?.clear();
                    _applyHireDateFilter(null, null);
                  },
                  child: const Text('Clear'),
                ),

              const SizedBox(width: 8),

              // Employment Status Dropdown
              SizedBox(
                width: 280,
                child: CustomDropdownFilter(
                  selectedValue: selectedEmploymentStatusOption,
                  options: employmentStatusOptions,
                  name: "Employment Status: ",
                  onChanged: (newStatus) {
                    setState(() {
                      selectedEmploymentStatusOption = newStatus;
                      employed = newStatus == 'true'
                          ? true
                          : newStatus == 'false'
                          ? false
                          : null;
                    });
                    loadData();
                  },
                ),
              ),

              const SizedBox(width: 8),

              // Sort By Dropdown
              SizedBox(
                width: 180,
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

              const SizedBox(width: 8),

              // Asc/Desc Toggle
              IconButton(
                icon: Icon(
                  _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                  color: colorScheme.onPrimaryContainer,
                ),
                tooltip: _sortAscending ? 'Ascending' : 'Descending',
                onPressed: () {
                  setState(() => _sortAscending = !_sortAscending);
                  loadData();
                },
              ),

              const SizedBox(width: 8),

              // Refresh Button
              TextButton.icon(
                onPressed: () {
                  // if (_ftsController.text.isEmpty == false ||
                  //     _sortBy != null ||
                  //     selectedSortingOption != null ||
                  //     selectedEmploymentStatusOption != null ||
                  //     employed != null ||
                  //     //_pickerKey.currentState != null ||
                  //     _from != null ||
                  //     _to != null) {
                  _ftsController.clear();
                  _sortBy = null;
                  selectedSortingOption = null;
                  selectedEmploymentStatusOption = null;
                  employed = null;
                  _pickerKey.currentState?.clear();
                  _applyHireDateFilter(null, null);
                  //loadData(page: 0);
                  //   _reloadTable();
                  // } else {
                  //   loadData(page: 0);
                  //   _reloadCurrentPageTable();
                  // }
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

  Widget _buildResultView() {
    if (isLoading && (employees == null || employees!.result.isEmpty)) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }

    return (employees != null && employees?.result.isEmpty == false)
        ? Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: EmployeeTable(
                key: tableKey,
                result: employees,
                onPageChanged: loadData,
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(128.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NoResultsWidget(
                  message: 'No results found. Please try again.',
                  icon: Icons.sentiment_dissatisfied,
                ),
              ],
            ),
          );
  }
}

class EmployeeTable extends StatefulWidget {
  final SearchResult<Employee>? result;
  final Future<void> Function({int page}) onPageChanged;

  const EmployeeTable({super.key, this.result, required this.onPageChanged});

  @override
  State<EmployeeTable> createState() => _EmployeeTableState();
}

class _EmployeeTableState extends State<EmployeeTable> {
  final int _pageSize = 10;
  int currentPage = 0;
  bool isLoading = false;
  EmployeeDataSource? _dataSource;
  late EmployeeProvider employeeProvider;

  @override
  void initState() {
    super.initState();
    _updateDataSource();
    employeeProvider = context.read<EmployeeProvider>();
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

    final permissionProvider = Provider.of<PermissionProvider>(
      context,
      listen: false,
    );

    final canViewEmployeeDetails = permissionProvider.canGetByIdEmployee();
    final canDeleteEmployee = permissionProvider.canDeleteEmployee();

    _dataSource = EmployeeDataSource(
      employees,
      context,
      delete,
      totalCount,
      onPageChanged: _fetchPage,
      pageSize: _pageSize,
      currentPage: currentPage,
      canViewEmployeeDetails: canViewEmployeeDetails,
      canDeleteEmployee: canDeleteEmployee,
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

  void delete(Employee employee) async {
    final id = employee.user?.userId;

    final shouldProceed = await CustomConfirmDialog.show(
      context,
      icon: Icons.info,

      title: 'Delete Employee',
      content: 'Are you sure you want to delete this employee?',
      confirmText: 'Delete',
      cancelText: 'Cancel',
    );

    if (shouldProceed != true) return;

    final success = await employeeProvider.delete(id!);

    CustomSnackbar.show(
      context,
      message: success
          ? 'Employee successfully deleted.'
          : 'Something went wrong. Please try again.',
      type: success ? SnackbarType.success : SnackbarType.error,
    );

    if (success) {
      _fetchPage(currentPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final employees = widget.result?.result ?? [];
    //final totalCount = widget.result?.totalCount ?? 0;

    if (isLoading && employees.isEmpty) {
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
          columns: const [
            DataColumn2(label: Text('Employee Name')),
            DataColumn2(label: Text('Job Title')),
            DataColumn2(label: Text('Email')),
            DataColumn2(label: Text('Phone Number')),
            DataColumn2(
              label: Text('Employment Status'),
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
            if (newPage != currentPage && !isLoading) {
              _fetchPage(newPage);
            }
          },
          initialFirstRowIndex: currentPage * _pageSize,
          columnSpacing: 15,
          horizontalMargin: 14,
          minWidth: 600,
          showCheckboxColumn: false,
          availableRowsPerPage: const [10],
          renderEmptyRowsInTheEnd: false,
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

class EmployeeDataSource extends DataTableSource {
  final List<Employee> employees;
  final BuildContext context;
  final int? count;
  final Future<void> Function(int page)? onPageChanged;
  final void Function(Employee employee) delete;
  final int pageSize;
  final int currentPage;
  final bool canViewEmployeeDetails;
  final bool canDeleteEmployee;

  EmployeeDataSource(
    this.employees,
    this.context,
    this.delete,
    this.count, {
    this.onPageChanged,
    this.pageSize = 10,
    this.currentPage = 0,
    required this.canViewEmployeeDetails,
    required this.canDeleteEmployee,
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
        DataCell(Text(employee.user?.email ?? "Not provided")),
        DataCell(Text(employee.user?.phoneNumber ?? "Not provided")),
        DataCell(
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: employee.endDate == null
                  ? const Color.fromRGBO(204, 245, 215, 1)
                  : Colors.red.shade50,
              border: null,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              employee.endDate == null ? "Employed" : "Not Employed",
              style: TextStyle(
                color: employee.endDate == null
                    ? Color.fromARGB(255, 80, 80, 80)
                    : Colors.red,
              ),
            ),
          ),
        ),
        DataCell(
          Center(
            child: PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'details') {
                  if (!canViewEmployeeDetails) {
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
                          create: (_) => EmployeeFormProvider(),
                          child: EmployeeDetailsScreen(employee: employee),
                        ),
                      ),
                    );

                    if (result == true && onPageChanged != null) {
                      onPageChanged!(currentPage);
                    }
                  }
                } else if (value == 'delete') {
                  if (!canDeleteEmployee) {
                    CustomSnackbar.show(
                      context,
                      message:
                          'You do not have permission to perform this action.',
                      type: SnackbarType.error,
                    );
                  } else {
                    delete(employee);
                  }
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'details',
                  child: Text('View employee details'),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete employee'),
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
