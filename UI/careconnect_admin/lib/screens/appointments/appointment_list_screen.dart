import 'package:careconnect_admin/core/layouts/master_screen.dart';
import 'package:careconnect_admin/core/theme/app_colors.dart';
import 'package:careconnect_admin/models/enums/appointment_status.dart';
import 'package:careconnect_admin/models/responses/appointment.dart';
import 'package:careconnect_admin/models/responses/child.dart';
import 'package:careconnect_admin/models/responses/employee.dart';
import 'package:careconnect_admin/models/responses/search_result.dart';
import 'package:careconnect_admin/providers/appointment_provider.dart';
import 'package:careconnect_admin/providers/child_provider.dart';
import 'package:careconnect_admin/providers/employee_provider.dart';
import 'package:careconnect_admin/providers/permission_provider.dart';
import 'package:careconnect_admin/screens/appointments/appointment_details_screen.dart';
import 'package:careconnect_admin/screens/no_permission_screen.dart';
import 'package:careconnect_admin/widgets/confirm_dialog.dart';
import 'package:careconnect_admin/widgets/custom_dropdown_fliter.dart';
import 'package:careconnect_admin/widgets/no_results.dart';
import 'package:careconnect_admin/widgets/snackbar.dart';
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
  late PermissionProvider permissionProvider;

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
    'Reschedule Requested': 'RescheduleRequested',
    'Reschedule Pending Approval': 'ReschedulePendingApproval',
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
    permissionProvider = Provider.of<PermissionProvider>(
      context,
      listen: false,
    );

    loadData();
    if (permissionProvider.canGetEmployees()) loadEmployees();
    if (permissionProvider.canGetChildren()) loadChildren();
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
    final response = await childProvider.get(filter: {"retrieveAll": true});

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

    if (!permissionProvider.canViewAppointmentScreen()) {
      return MasterScreen(
        'Appointments',
        NoPermissionScreen(),
        currentScreen: "Appointments",
      );
    }

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
      currentScreen: "Appointments",
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
              if (permissionProvider.canGetEmployees())
                SizedBox(
                  width: 220,
                  child: CustomDropdownFilter(
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

              if (permissionProvider.canGetChildren())
                // Child
                SizedBox(
                  width: 220,
                  child: CustomDropdownFilter(
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
                  width: 270,
                  child: CustomDropdownFilter(
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
    if (isLoading && (result == null || result!.result.isEmpty)) {
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
                onActionSelected: (appointment, action) {
                  switch (action) {
                    case 'Cancel':
                      if (permissionProvider.canCancelAppointment()) {
                        _cancelAppointment(appointment);
                      } else {
                        _showNoPermission();
                      }
                      break;
                    case 'Confirm':
                      if (permissionProvider.canConfirmAppointment()) {
                        _confirmAppointment(appointment);
                      } else {
                        _showNoPermission();
                      }
                      break;
                    case 'Reschedule':
                      if (permissionProvider.canRescheduleAppointment()) {
                        _rescheduleAppointment(appointment);
                      } else {
                        _showNoPermission();
                      }
                    case 'Request Reschedule':
                      if (permissionProvider.canRescheduleAppointment()) {
                        _requestRescheduleAppointment(appointment);
                      } else {
                        _showNoPermission();
                      }
                    case 'Start':
                      if (permissionProvider.canStartAppointment()) {
                        _startAppointment(appointment);
                      } else {
                        _showNoPermission();
                      }
                    case 'Complete':
                      if (permissionProvider.canCompleteAppointment()) {
                        _completeAppointment(appointment);
                      } else {
                        _showNoPermission();
                      }
                      break;
                    default:
                      print('Unknown action: $action');
                  }
                },
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

  void _showNoPermission() {
    CustomSnackbar.show(
      context,
      message: 'You do not have permission to perform this action.',
      type: SnackbarType.error,
    );
  }

  Future<void> _handleAppointmentAction({
    required Appointment appointment,
    required String title,
    required String content,
    required String confirmText,
    required Future<bool> Function({required int appointmentId}) action,
    required String successMessage,
  }) async {
    final shouldProceed = await CustomConfirmDialog.show(
      context,
      icon: Icons.info,
      iconBackgroundColor: AppColors.mauveGray,
      title: title,
      content: content,
      confirmText: confirmText,
      cancelText: 'Cancel',
    );

    if (shouldProceed != true) return;

    final success = await action(appointmentId: appointment.appointmentId);

    if (!mounted) return;

    if (success) {
      final updatedAppointment = appointmentProvider.item.result.firstWhere(
        (a) => a.appointmentId == appointment.appointmentId,
      );

      final index = tableKey.currentState?._dataSource?.appointments.indexWhere(
        (a) => a.appointmentId == updatedAppointment.appointmentId,
      );

      if (index != null && index != -1) {
        tableKey.currentState!._dataSource!.appointments[index] =
            updatedAppointment;
        tableKey.currentState!._dataSource!.notifyListeners();
      }
    }

    CustomSnackbar.show(
      context,
      message: success
          ? successMessage
          : 'Something went wrong. Please try again.',
      type: success ? SnackbarType.success : SnackbarType.error,
    );
  }

  void _cancelAppointment(Appointment appointment) => _handleAppointmentAction(
    appointment: appointment,
    title: 'Cancel Appointment',
    content: 'Are you sure you want to cancel appointment?',
    confirmText: 'Confirm',
    action: appointmentProvider.cancelAppointment,
    successMessage: 'You have successfully canceled the appointment.',
  );

  void _confirmAppointment(Appointment appointment) => _handleAppointmentAction(
    appointment: appointment,
    title: 'Confirm Appointment',
    content: 'Are you sure you want to confirm appointment?',
    confirmText: 'Confirm',
    action: appointmentProvider.confirmAppointment,
    successMessage: 'You have successfully confirmed the appointment.',
  );

  void _rescheduleAppointment(Appointment appointment) =>
      _handleAppointmentAction(
        appointment: appointment,
        title: 'Reschedule Appointment',
        content: 'Are you sure you want to confirm rescheduling appointment?',
        confirmText: 'Reschedule',
        action: appointmentProvider.rescheduleAppointmet,
        successMessage:
            'You have successfully confirmed rescheduling the appointment.',
      );

  void _requestRescheduleAppointment(
    Appointment appointment,
  ) => _handleAppointmentAction(
    appointment: appointment,
    title: 'Request Rescheduling Appointment',
    content: 'Are you sure you want to request rescheduling appointment?',
    confirmText: 'Reschedule',
    action: appointmentProvider.requestReschedule,
    successMessage:
        'You have successfully requested rescheduling. You will be notified when the client chooses a new appointment.',
  );

  void _startAppointment(Appointment appointment) => _handleAppointmentAction(
    appointment: appointment,
    title: 'Start Appointment',
    content: 'Are you sure you want to start appointment?',
    confirmText: 'Start',
    action: appointmentProvider.startAppointment,
    successMessage: 'You have successfully started the appointment.',
  );

  void _completeAppointment(Appointment appointment) =>
      _handleAppointmentAction(
        appointment: appointment,
        title: 'Complete Appointment',
        content: 'Are you sure you want to complete appointment?',
        confirmText: 'Complete',
        action: appointmentProvider.completeAppointment,
        successMessage: 'You have successfully completed the appointment.',
      );
}

class AppointmentTable extends StatefulWidget {
  final SearchResult<Appointment>? result;
  final Future<void> Function({int page}) onPageChanged;
  final void Function(Appointment appointment, String action) onActionSelected;

  const AppointmentTable({
    super.key,
    this.result,
    required this.onPageChanged,
    required this.onActionSelected,
  });

  @override
  State<AppointmentTable> createState() => _AppointmentTableState();
}

class _AppointmentTableState extends State<AppointmentTable> {
  final int _pageSize = 10;
  int currentPage = 0;
  bool isLoading = false;
  AppointmentDataSource? _dataSource;
  late AppointmentProvider appointmentProvider;
  // late PermissionProvider permissionProvider;

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

    final permissionProvider = Provider.of<PermissionProvider>(
      context,
      listen: false,
    );

    final canViewDetails = permissionProvider.canGetByIdAppointment();
    final canDeleteAppointment = permissionProvider.canDeleteAppointment();

    _dataSource = AppointmentDataSource(
      appointments,
      context,
      delete,
      totalCount,
      onPageChanged: _fetchPage,
      pageSize: _pageSize,
      currentPage: currentPage,
      onActionSelected: widget.onActionSelected,
      canViewDetails: canViewDetails,
      canDeleteAppointment: canDeleteAppointment,
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

  void delete(Appointment appointment) async {
    final id = appointment.appointmentId;

    if (appointment.stateMachine != 'Completed') {
      CustomSnackbar.show(
        context,
        message: 'You can only delete completed appointments.',
        type: SnackbarType.error,
      );

      return;
    }

    final shouldProceed = await CustomConfirmDialog.show(
      context,
      icon: Icons.info,

      title: 'Delete Appointment',
      content: 'Are you sure you want to delete this appointment?',
      confirmText: 'Delete',
      cancelText: 'Cancel',
    );

    if (shouldProceed != true) return;

    try {
      final result = await appointmentProvider.delete(id);

      if (result['success']) {
        CustomSnackbar.show(
          context,
          message: 'Appointment successfully deleted.',
          type: SnackbarType.success,
        );

        _fetchPage(currentPage);
      } else {
        CustomSnackbar.show(
          context,
          message: result['message'],
          type: SnackbarType.error,
        );
      }
    } catch (e) {
      CustomSnackbar.show(
        context,
        message: 'Something went wrong. Please try again later.',
        type: SnackbarType.error,
      );
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
            DataColumn2(label: Text('Client'), size: ColumnSize.M),
            DataColumn2(label: Text('Child'), size: ColumnSize.M),
            DataColumn2(label: Text('Employee'), size: ColumnSize.M),
            DataColumn2(label: Text('Service'), size: ColumnSize.L),
            DataColumn2(label: Text('Date'), size: ColumnSize.S),
            DataColumn2(label: Text('Time'), size: ColumnSize.S),
            DataColumn2(label: Text('Status'), size: ColumnSize.L),
            DataColumn2(label: Text('Change status'), size: ColumnSize.S),
            // if (permissionProvider.canGetByIdAppointment())
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
          columnSpacing: 4,
          horizontalMargin: 8,
          minWidth: 800,
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

class AppointmentDataSource extends DataTableSource {
  final List<Appointment> appointments;
  final BuildContext context;
  final int? count;
  final Future<void> Function(int page)? onPageChanged;
  final void Function(Appointment appointment) delete;

  final int pageSize;
  final int currentPage;
  final void Function(Appointment appointment, String action) onActionSelected;
  final bool canViewDetails;
  final bool canDeleteAppointment;

  AppointmentDataSource(
    this.appointments,
    this.context,
    this.delete,
    this.count, {
    this.onPageChanged,
    this.pageSize = 10,
    this.currentPage = 0,
    required this.onActionSelected,
    required this.canViewDetails,
    required this.canDeleteAppointment,
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
          SizedBox(
            width: 120, // adjust as needed
            child: DropdownButton<String>(
              isExpanded: true,
              hint: const Text("Actions"),
              underline: SizedBox.shrink(),
              items: appointmentStatusFromString(appointment.stateMachine ?? '')
                  .allowedActions
                  .map(
                    (action) =>
                        DropdownMenuItem(value: action, child: Text(action)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  onActionSelected(appointment, value);
                }
              },
            ),
          ),
        ),

        DataCell(
          Center(
            child: PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'details') {
                  if (!canViewDetails) {
                    CustomSnackbar.show(
                      context,
                      message:
                          'You do not have permission to perform this action.',
                      type: SnackbarType.error,
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                          create: (_) => AppointmentProvider(),
                          child: AppointmentDetailsScreen(
                            appointment: appointment,
                          ),
                        ),
                      ),
                    ).then((result) async {
                      if (result == true && onPageChanged != null) {
                        await onPageChanged!(currentPage);
                      }
                    });
                  }
                } else if (value == 'delete') {
                  if (!canDeleteAppointment) {
                    CustomSnackbar.show(
                      context,
                      message:
                          'You do not have permission to perform this action.',
                      type: SnackbarType.error,
                    );
                  } else {
                    delete(appointment);
                  }
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'details',
                  child: Text('View appointment details'),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete appointment'),
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
  int get rowCount => count ?? appointments.length;

  @override
  int get selectedRowCount => 0;

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
