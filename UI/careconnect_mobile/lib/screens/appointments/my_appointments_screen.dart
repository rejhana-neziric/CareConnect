import 'package:careconnect_mobile/models/auth_user.dart';
import 'package:careconnect_mobile/models/enums/appointment_status.dart';
import 'package:careconnect_mobile/models/responses/appointment.dart';
import 'package:careconnect_mobile/models/responses/search_result.dart';
import 'package:careconnect_mobile/models/responses/service_type.dart';
import 'package:careconnect_mobile/providers/appointment_provider.dart';
import 'package:careconnect_mobile/providers/auth_provider.dart';
import 'package:careconnect_mobile/providers/permission_provider.dart';
import 'package:careconnect_mobile/providers/service_type_provider.dart';
import 'package:careconnect_mobile/providers/utils.dart';
import 'package:careconnect_mobile/screens/appointments/appointment_details_screen.dart';
import 'package:careconnect_mobile/screens/no_permission_screen.dart';
import 'package:careconnect_mobile/widgets/filter/filter_config.dart';
import 'package:careconnect_mobile/widgets/filter/filter_option.dart';
import 'package:careconnect_mobile/widgets/filter/filter_section.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MyAppointmentsScreen extends StatefulWidget {
  const MyAppointmentsScreen({super.key});

  @override
  State<MyAppointmentsScreen> createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen> {
  bool isLoading = false;

  late AppointmentProvider appointmentProvider;
  late ServiceTypeProvider serviceTypeProvider;

  List<Appointment> appointments = [];

  AuthUser? currentUser;

  SearchResult<ServiceType>? serviceTypes;
  int? selectedServiceTypeId;
  List<FilterOption> serviceTypeOptions = [];

  String? _sortBy;
  bool _sortAscending = true;

  final TextEditingController _searchController = TextEditingController();
  String? serviceName;

  @override
  void initState() {
    super.initState();

    appointmentProvider = context.read<AppointmentProvider>();
    serviceTypeProvider = context.read<ServiceTypeProvider>();

    final auth = Provider.of<AuthProvider>(context, listen: false);

    setState(() {
      currentUser = auth.user;
    });

    final permissionProvider = context.read<PermissionProvider>();

    if (permissionProvider.canGetAppointments()) loadAppointments();
    if (permissionProvider.canGetServiceTypes()) loadServiceTypes();
  }

  Future<void> loadAppointments() async {
    setState(() {
      isLoading = true;
    });

    final response = await appointmentProvider.loadData(
      clientUsername: currentUser?.username,
      serviceTypeId: selectedServiceTypeId,
      status: selectedStatus,
      serviceNameGTE: serviceName,
      sortBy: _sortBy,
      sortAscending: _sortAscending,
      retrieveAll: true,
    );

    setState(() {
      appointments = response?.result ?? [];
      isLoading = false;
    });
  }

  Future<void> loadServiceTypes() async {
    final result = await serviceTypeProvider.loadData();

    setState(() {
      serviceTypes = result;

      if (serviceTypes != null) {
        serviceTypeOptions = [
          FilterOption(key: 'all', label: 'ALL', isSelected: true),
          for (final type in serviceTypes!.result)
            FilterOption<int>(key: type.serviceTypeId, label: type.name),
        ];
      }
    });
  }

  List<FilterOption<String>> buildStatusOptions() {
    final currentSelection = getFirstFilterValue('status').isEmpty
        ? 'all'
        : getFirstFilterValue('status');
    return statusOptions.map((o) {
      return FilterOption<String>(
        key: o.key,
        label: o.label,
        isSelected: o.key == currentSelection,
      );
    }).toList();
  }

  List<FilterOption<String>> buildServiceTypeOptions() {
    final currentSelection = getFirstFilterValue('service type').isEmpty
        ? 'all'
        : getFirstFilterValue('service type');

    return serviceTypeOptions.map((o) {
      return FilterOption<String>(
        key: o.key.toString(),
        label: o.label,
        isSelected: o.key.toString() == currentSelection,
      );
    }).toList();
  }

  List<FilterOption<String>> buildSortByOptions() {
    return [
      FilterOption<String>(
        key: 'notSorted',
        label: 'Not sorted',
        isSelected: _sortBy == null,
      ),
      FilterOption<String>(
        key: 'employeeFirstName',
        label: 'Employee First Name',
        isSelected: _sortBy == 'employeeFirstName',
      ),
      FilterOption<String>(
        key: 'employeeLastName',
        label: 'Employee Last Name',
        isSelected: _sortBy == 'employeeLastName',
      ),
      FilterOption<String>(
        key: 'date',
        label: 'Date',
        isSelected: _sortBy == 'date',
      ),
      FilterOption<String>(
        key: 'status',
        label: 'Status',
        isSelected: _sortBy == 'status',
      ),
    ];
  }

  List<FilterOption<String>> buildSortDirectionOptions() {
    return [
      FilterOption<String>(
        key: 'asc',
        label: 'Ascending',
        isSelected: _sortAscending,
      ),
      FilterOption<String>(
        key: 'dsc',
        label: 'Descending',
        isSelected: !_sortAscending,
      ),
    ];
  }

  List<FilterOption<String>> statusOptions = [
    FilterOption(key: 'all', label: 'ALL', isSelected: true),
    FilterOption(key: 'scheduled', label: 'Scheduled'),
    FilterOption(key: 'confirmed', label: 'Confirmed'),
    FilterOption(key: 'rescheduled', label: 'Rescheduled'),
    FilterOption(key: 'canceled', label: 'Canceled'),
    FilterOption(key: 'started', label: 'Started'),
    FilterOption(key: 'completed', label: 'Completed'),
  ];

  String selectedStatusKey = 'all';
  String? selectedStatus;

  Map<String, List<String>> appliedFilters = {};

  FilterConfig get filterConfig {
    final permissionProvider = context.read<PermissionProvider>();

    final sections = <FilterSection>[
      FilterSection(
        title: 'Status',
        allowMultipleSelection: false,
        options: buildStatusOptions(),
      ),
    ];

    if (permissionProvider.canGetServiceTypes()) {
      sections.add(
        FilterSection(
          title: 'Service Type',
          allowMultipleSelection: false,
          options: buildServiceTypeOptions(),
        ),
      );
    }

    sections.addAll([
      FilterSection(
        title: 'Sort by',
        allowMultipleSelection: false,
        options: buildSortByOptions(),
      ),
      FilterSection(
        title: 'Sort direction',
        allowMultipleSelection: false,
        options: buildSortDirectionOptions(),
      ),
    ]);

    return FilterConfig(title: 'Filters', sections: sections);
  }

  String getFirstFilterValue(String filterKey) {
    final values = appliedFilters[filterKey];
    return values != null && values.isNotEmpty ? values.first : '';
  }

  void _showFilters() {
    showGenericFilter(
      context: context,
      config: filterConfig,
      initialFilters: appliedFilters,
      onApply: _handleFilterApply,
      onClearAll: _handleClearAll,
    );
  }

  void _handleFilterApply(Map<String, List<String>> filters) {
    setState(() {
      appliedFilters = filters;

      final serviceValue = getFirstFilterValue('service type');
      selectedServiceTypeId = (serviceValue.isNotEmpty && serviceValue != 'all')
          ? int.tryParse(serviceValue)
          : null;

      final statusValue = getFirstFilterValue('status');
      selectedStatus = (statusValue == 'all' || statusValue.isEmpty)
          ? null
          : statusValue;
      selectedStatusKey = statusValue.isNotEmpty ? statusValue : 'all';

      final sortByValue = getFirstFilterValue('sort by');
      _sortBy = (sortByValue == 'notSorted' || sortByValue.isEmpty)
          ? null
          : sortByValue;

      final sortDirectionValue = getFirstFilterValue('sort direction');
      _sortAscending = sortDirectionValue != 'dsc';
    });

    loadAppointments();
  }

  void _handleClearAll() {
    setState(() {
      appliedFilters = {
        'status': ['all'],
        'service type': ['all'],
        'sort by': ['notSorted'],
        'sort direction': ['asc'],
      };

      selectedServiceTypeId = null;
      selectedStatus = null;
      selectedStatusKey = 'all';
      _sortBy = null;
      _sortAscending = true;
    });

    loadAppointments();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final permissionProvider = context.read<PermissionProvider>();

    if (!permissionProvider.canGetAppointments()) {
      return Scaffold(
        backgroundColor: colorScheme.surfaceContainerLow,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: colorScheme.surfaceContainerLow,
          foregroundColor: colorScheme.onSurface,
          title: Text(
            'Appointments',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: NoPermissionScreen()),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLow,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.surfaceContainerLow,
        foregroundColor: colorScheme.onSurface,
        title: Text(
          'Appointments',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: colorScheme.onSurface,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Search bar
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search by service name...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      isDense: true,
                    ),
                    onChanged: (value) {
                      setState(() {
                        serviceName = value;
                      });
                      loadAppointments();
                    },
                  ),
                ),
                const SizedBox(width: 8),

                // Filter button
                IconButton(
                  onPressed: _showFilters,
                  icon: const Icon(Icons.tune),
                  tooltip: "Open filters",
                ),
              ],
            ),
          ),
          Expanded(child: _buildMyAppointments(colorScheme)),
        ],
      ),
    );
  }

  Widget _buildMyAppointments(ColorScheme colorScheme) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (appointments.isEmpty) {
      return const Center(
        child: Text(
          "No appointments found.",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: appointments.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return _buildAppointmentCard(appointment, colorScheme);
      },
    );
  }

  Widget _buildAppointmentCard(
    Appointment appointment,
    ColorScheme colorScheme,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${appointment.employeeAvailability?.employee.user?.firstName ?? ''} '
                  '${appointment.employeeAvailability?.employee.user?.lastName ?? ''}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  appointment.employeeAvailability?.employee.jobTitle ?? '',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 12),
                Text(
                  appointment.employeeAvailability?.service?.name ?? '',
                  style: TextStyle(color: colorScheme.primary),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.date_range, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        DateFormat('d. M. y.').format(appointment.date),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      '${appointment.employeeAvailability?.startTime ?? ''} - '
                      '${appointment.employeeAvailability?.endTime ?? ''}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 130,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AppointmentDetailsScreen(appointment: appointment),
                      ),
                    );

                    loadAppointments();
                  },
                  icon: const Icon(Icons.chevron_right, color: Colors.grey),
                ),

                if (appointment.stateMachine != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: appointmentStatusFromString(
                        appointment.stateMachine!,
                      ).backgroundColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      appointmentStatusFromString(
                        appointment.stateMachine!,
                      ).label,
                      style: TextStyle(
                        color: appointmentStatusFromString(
                          appointment.stateMachine!,
                        ).textColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
