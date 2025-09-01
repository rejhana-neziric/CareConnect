import 'package:careconnect_admin/core/layouts/master_screen.dart';
import 'package:careconnect_admin/models/enums/appointment_status.dart';
import 'package:careconnect_admin/models/responses/appointment.dart';
import 'package:careconnect_admin/models/responses/child.dart';
import 'package:careconnect_admin/models/responses/employee.dart';
import 'package:careconnect_admin/models/responses/search_result.dart';
import 'package:careconnect_admin/providers/appointment_provider.dart';
import 'package:careconnect_admin/providers/child_provider.dart';
import 'package:careconnect_admin/providers/employee_provider.dart';
import 'package:careconnect_admin/widgets/custom_dropdown_fliter.dart';
import 'package:careconnect_admin/widgets/no_results.dart';
import 'package:careconnect_admin/widgets/primary_button.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AppointmentListScreen extends StatefulWidget {
  const AppointmentListScreen({super.key});

  @override
  State<AppointmentListScreen> createState() => _AppointmentListScreenState();
}

class _AppointmentListScreenState extends State<AppointmentListScreen> {
  late AppointmentProvider appointmentProvider;
  late EmployeeProvider employeeProvider;
  late ChildProvider childProvider;

  SearchResult<Appointment>? result;
  int currentPage = 0;

  bool isLoading = false;

  final TextEditingController _ftsController = TextEditingController();

  String? _sortBy;
  bool _sortAscending = true;

  String? selectedSortingOption;

  final Map<String, String?> sortingOptions = {
    'Not sorted': null,
    'Employee First Name': 'employeeFirstName',
    'Employee Last Name': 'employeeLastName',
    'Clients First Name': 'clientFirstName',
    'Clients Last Name': 'clientLastName',
    'Childs First Name': 'childFirstName',
    'Childs Last Name': 'childLastName',
    'Date': 'date',
    'Status': 'status',
  };

  List<Employee> employees = [];
  Map<String, String?> employeesOption = {};
  String? selectedEmployee;

  List<Child> children = [];
  Map<String, String?> childrenOption = {};
  String? selectedChild;

  String? selectedStatusOption;

  final Map<String, String?> statusOptions = {
    'All Status': null,
    'Scheduled': 'Scheduled',
    'Confirmed': 'Confirmed',
    'Rescheduled': 'Rescheduled',
    'Canceled': 'Canceled',
    'Started': 'Started',
    'Completed': 'Completed',
  };

  final GlobalKey<_AppointmentTableState> tableKey = GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    appointmentProvider = context.read<AppointmentProvider>();
    employeeProvider = context.read<EmployeeProvider>();
    childProvider = context.read<ChildProvider>();
    loadData();
    loadEmployees();
    loadChildren();
  }

  Future<void> loadData({int page = 0}) async {
    setState(() {
      isLoading = true;
    });

    try {
      tableKey.currentState?.currentPage = 0;

      final appointmentProvider = Provider.of<AppointmentProvider>(
        context,
        listen: false,
      );

      List<String> partsEmployee = selectedEmployee?.split(" ") ?? [];
      List<String> partsChild = selectedChild?.split(" ") ?? [];

      final finalResult = await appointmentProvider.loadData(
        fts: _ftsController.text,
        appointmentType: _ftsController.text,
        employeeFirstName: partsEmployee.isNotEmpty == true
            ? partsEmployee.first
            : null,
        employeeLastName: partsEmployee.length > 1
            ? partsEmployee.sublist(1).join(" ")
            : null,
        childFirstName: partsChild.isNotEmpty == true ? partsChild.first : null,
        childLastName: partsChild.length > 1
            ? partsChild.sublist(1).join(" ")
            : null,
        dateGTE: null,
        dateLTE: null,
        attendanceStatusName: null,
        startTime: null,
        endTime: null,
        page: page,
        status: selectedStatusOption,
        sortBy: _sortBy,
        sortAscending: _sortAscending,
      );

      result = finalResult;

      if (mounted) {
        setState(() {});
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> loadEmployees() async {
    final response = await employeeProvider.loadData();

    setState(() {
      employees = response?.result ?? [];

      employeesOption = {
        'All': null,
        for (final employee in employees)
          '${employee.user?.firstName} ${employee.user?.lastName}':
              '${employee.user?.firstName} ${employee.user?.lastName}',
      };
    });
  }

  Future<void> loadChildren() async {
    final response = await childProvider.get();

    setState(() {
      children = response.result;

      childrenOption = {
        'All': null,
        for (final child in children)
          '${child.firstName} ${child.lastName}':
              '${child.firstName} ${child.lastName}',
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MasterScreen(
      'Appointments',
      Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildSearch(colorScheme),
            Consumer<AppointmentProvider>(
              builder: (context, appointmentProvider, child) {
                return _buildResultView();
              },
            ),
          ],
        ),
      ),
      button: PrimaryButton(onPressed: () {}, label: 'Add Appointment'),
    );
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
              // Employee
              SizedBox(
                width: 220,
                child: CustomDropdownFliter(
                  selectedValue: selectedEmployee,
                  options: employeesOption,
                  name: "Employee: ",
                  onChanged: (newEmployee) {
                    setState(() {
                      selectedEmployee = newEmployee;
                    });
                    loadData();
                  },
                ),
              ),

              const SizedBox(width: 8),

              // Child
              SizedBox(
                width: 220,
                child: CustomDropdownFliter(
                  selectedValue: selectedChild,
                  options: childrenOption,
                  name: "Child: ",
                  onChanged: (newChild) {
                    setState(() {
                      selectedChild = newChild;
                    });
                    loadData();
                  },
                ),
              ),

              const SizedBox(width: 8),

              // Status
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 250),
                child: Container(
                  color: colorScheme.surfaceContainerLowest,
                  width: 180,
                  child: CustomDropdownFliter(
                    selectedValue: selectedStatusOption,
                    options: statusOptions,
                    name: "Status: ",
                    onChanged: (newStatus) {
                      setState(() {
                        selectedStatusOption = newStatus;
                      });
                      loadData();
                    },
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Sort By Dropdown
              SizedBox(
                width: 220,
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
                  _ftsController.clear();
                  _sortBy = null;
                  selectedEmployee = null;
                  selectedChild = null;
                  selectedStatusOption = null;
                  selectedSortingOption = null;
                  loadData();
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
    if (isLoading) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }

    if (result != null && result?.result.isEmpty == false) {
      return Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 1500,
              child: AppointmentTable(
                key: tableKey,
                result: result,
                onPageChanged: loadData,
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(128.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          NoResultsWidget(
            message: 'No appointments found.',
            icon: Icons.sentiment_dissatisfied,
          ),
        ],
      ),
    );
  }
}

class AppointmentTable extends StatefulWidget {
  final SearchResult<Appointment>? result;
  final Future<void> Function({int page}) onPageChanged;

  const AppointmentTable({super.key, this.result, required this.onPageChanged});

  @override
  State<AppointmentTable> createState() => _AppointmentTableState();
}

class _AppointmentTableState extends State<AppointmentTable> {
  final int _pageSize = 10;
  int currentPage = 0;
  bool isLoading = false;
  AppointmentDataSource? _dataSource;
  late AppointmentProvider appointmentProvider;

  bool isHoveredParent = false;
  bool isHoveredChild = false;

  @override
  void initState() {
    super.initState();
    _updateDataSource();
    appointmentProvider = context.read<AppointmentProvider>();
  }

  @override
  void didUpdateWidget(AppointmentTable oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.result != widget.result) {
      _updateDataSource();
    }
  }

  void _updateDataSource() {
    final appointments = widget.result?.result ?? [];
    final totalCount = widget.result?.totalCount ?? 0;

    _dataSource = AppointmentDataSource(
      appointments,
      context,
      totalCount,
      onPageChanged: _fetchPage,
      pageSize: _pageSize,
      currentPage: currentPage,
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
    final appointments = widget.result?.result ?? [];

    if (isLoading && appointments.isEmpty) {
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
          columns: [
            DataColumn2(label: Text('Client'), size: ColumnSize.S),
            DataColumn2(label: Text('Child'), size: ColumnSize.S),
            DataColumn2(label: Text('Employee'), size: ColumnSize.S),
            DataColumn2(label: Text('Service'), size: ColumnSize.L),
            DataColumn2(label: Text('Date'), size: ColumnSize.S),
            DataColumn2(label: Text('Time'), size: ColumnSize.S),
            DataColumn2(label: Text('Status'), size: ColumnSize.S),
            DataColumn2(label: Text('Actions'), size: ColumnSize.S),
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
          columnSpacing: 0,
          horizontalMargin: 12,
          minWidth: 400,
          showCheckboxColumn: false,
          availableRowsPerPage: const [10],
        ),
        if (isLoading)
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

class AppointmentDataSource extends DataTableSource {
  final List<Appointment> appointments;
  final BuildContext context;
  final int? count;
  final Future<void> Function(int page)? onPageChanged;
  final int pageSize;
  final int currentPage;

  AppointmentDataSource(
    this.appointments,
    this.context,
    this.count, {
    this.onPageChanged,
    this.pageSize = 10,
    this.currentPage = 0,
  });

  final ValueNotifier<int?> hoveredRowNotifier = ValueNotifier(null);

  @override
  DataRow? getRow(int index) {
    final requestedPage = index ~/ pageSize;

    if (requestedPage != currentPage) return null;

    final localIndex = index % pageSize;

    if (localIndex < 0 || localIndex >= appointments.length) return null;

    final appointment = appointments[localIndex];

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Text(
            '${appointment.clientsChild.client.user?.firstName} ${appointment.clientsChild.client.user?.lastName}',
          ),
        ),
        DataCell(
          Text(
            '${appointment.clientsChild.child.firstName} ${appointment.clientsChild.child.lastName}',
          ),
        ),
        DataCell(
          Text(
            '${appointment.employeeAvailability?.employee.user?.firstName} ${appointment.employeeAvailability?.employee.user?.lastName}',
          ),
        ),
        DataCell(
          Text(appointment.employeeAvailability?.service?.name ?? 'No service'),
        ),
        DataCell(
          Text(DateFormat('d. M. y.').format(appointment.date).toString()),
        ),
        DataCell(Text(appointment.employeeAvailability?.startTime ?? '')),
        DataCell(
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: appointmentStatusFromString(
                appointment.stateMachine ?? '',
              ).backgroundColor,
              border: null,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              appointmentStatusFromString(appointment.stateMachine ?? '').label,
              style: TextStyle(
                color: appointmentStatusFromString(
                  appointment.stateMachine ?? '',
                ).textColor,
              ),
            ),
          ),
        ),
        DataCell(
          DropdownButton<String>(
            hint: Text("Actions"),
            items: appointmentStatusFromString(appointment.stateMachine ?? '')
                .allowedActions
                .map(
                  (action) =>
                      DropdownMenuItem(value: action, child: Text(action)),
                )
                .toList(),
            onChanged: (value) {
              // todo
            },
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => count ?? appointments.length;

  @override
  int get selectedRowCount => 0;

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
