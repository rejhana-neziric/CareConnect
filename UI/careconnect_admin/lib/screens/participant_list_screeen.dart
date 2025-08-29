import 'package:careconnect_admin/core/layouts/master_screen.dart';
import 'package:careconnect_admin/models/responses/attendance_status.dart';
import 'package:careconnect_admin/models/responses/participant.dart';
import 'package:careconnect_admin/models/responses/search_result.dart';
import 'package:careconnect_admin/models/responses/workshop.dart';
import 'package:careconnect_admin/providers/attendance_status_provider.dart';
import 'package:careconnect_admin/providers/participant_provider.dart';
import 'package:careconnect_admin/widgets/custom_dropdown_fliter.dart';
import 'package:careconnect_admin/widgets/no_results.dart';
import 'package:careconnect_admin/widgets/primary_button.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ParticipantListScreeen extends StatefulWidget {
  final Workshop workshop;
  const ParticipantListScreeen({super.key, required this.workshop});

  @override
  State<ParticipantListScreeen> createState() => _ParticipantListScreeenState();
}

class _ParticipantListScreeenState extends State<ParticipantListScreeen> {
  late ParticipantProvider participantProvider;
  late AttendanceStatusProvider attendanceStatusProvider;

  SearchResult<Participant>? result;
  int currentPage = 0;

  bool isLoading = false;

  final TextEditingController _ftsController = TextEditingController();

  String? _sortBy;
  bool _sortAscending = true;

  List<AttendanceStatus> attendanceStatus = [];
  AttendanceStatus? selectedAttendanceStatus;
  Map<String, String?> attendanceOptions = {};

  String? selectedSortingOption;

  final Map<String, String?> sortingOptions = {
    'Not sorted': null,
    'First Name': 'firstName',
    'Last Name': 'lastName',
    'Registration Date': 'date',
    'Attendance Status': 'status',
  };

  final GlobalKey<_ParticipantTableState> tableKey = GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    participantProvider = context.read<ParticipantProvider>();
    attendanceStatusProvider = context.read<AttendanceStatusProvider>();
    loadData();
    loadAttendanceStatus();
  }

  Future<void> loadData({int page = 0}) async {
    setState(() {
      isLoading = true;
    });

    try {
      tableKey.currentState?.currentPage = 0;

      final participantProvider = Provider.of<ParticipantProvider>(
        context,
        listen: false,
      );

      final finalResult = await participantProvider.loadData(
        fts: _ftsController.text,
        workshopId: widget.workshop.workshopId,
        userFirstNameGTE: _ftsController.text,
        userLastNameGTE: _ftsController.text,
        attendanceStatusNameGTE: selectedAttendanceStatus?.name,
        page: page,
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

  Future<void> loadAttendanceStatus() async {
    var result = await attendanceStatusProvider.get();

    setState(() {
      attendanceStatus = result.result;
      attendanceOptions = {
        'All': null,
        for (final status in attendanceStatus)
          if (status.name != null) status.name!: status.name,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MasterScreen(
      "Participants",
      Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 1200,
                height: 50,
                child: Text(
                  "${widget.workshop.name}: ${result?.totalCount == 0 ? 'No participant found' : '${result?.totalCount} participant found'}",
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            _buildSearch(colorScheme),
            Consumer<ParticipantProvider>(
              builder: (context, clientsChildProvider, child) {
                return _buildResultView(widget.workshop);
              },
            ),
          ],
        ),
      ),
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
              // Search field
              SizedBox(
                width: 500,
                child: TextField(
                  controller: _ftsController,
                  decoration: InputDecoration(
                    labelText: "Search First Name and Last Name",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerLowest,
                  ),
                  onChanged: (value) => loadData(),
                ),
              ),
              const SizedBox(width: 8),
              //Sort By Attendance Status
              SizedBox(
                width: 220,
                child: CustomDropdownFliter(
                  selectedValue: selectedAttendanceStatus?.name,
                  options: attendanceOptions,
                  name: "Attendance Status: ",
                  onChanged: (newStatus) {
                    setState(() {
                      final idx = attendanceStatus.indexWhere(
                        (s) => s.name == newStatus,
                      );
                      selectedAttendanceStatus = idx == -1
                          ? null
                          : attendanceStatus[idx];
                    });
                    loadData();
                  },
                ),
              ),
              const SizedBox(width: 8),
              //Sort By Dropdown
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
                  selectedAttendanceStatus = null;
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

  Widget _buildResultView(Workshop workshop) {
    return (result != null && result?.result.isEmpty == false)
        ? Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 1200,
                  child: ParticipantTable(
                    key: tableKey,
                    result: result,
                    workshop: workshop,
                    onPageChanged: loadData,
                  ),
                ),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(128.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NoResultsWidget(
                  message: 'No participant found.',
                  icon: Icons.sentiment_dissatisfied,
                ),
              ],
            ),
          );
  }
}

class ParticipantTable extends StatefulWidget {
  final SearchResult<Participant>? result;
  final Workshop workshop;
  final Future<void> Function({int page}) onPageChanged;

  const ParticipantTable({
    super.key,
    this.result,
    required this.workshop,
    required this.onPageChanged,
  });

  @override
  State<ParticipantTable> createState() => _ParticipantTableState();
}

class _ParticipantTableState extends State<ParticipantTable> {
  final int _pageSize = 10;
  int currentPage = 0;
  bool isLoading = false;
  ParticipantDataSource? _dataSource;
  late ParticipantProvider participantProvider;

  bool isHoveredParent = false;
  bool isHoveredChild = false;

  @override
  void initState() {
    super.initState();
    _updateDataSource();
    participantProvider = context.read<ParticipantProvider>();
  }

  @override
  void didUpdateWidget(ParticipantTable oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.result != widget.result) {
      _updateDataSource();
    }
  }

  void _updateDataSource() {
    final participants = widget.result?.result ?? [];
    final totalCount = widget.result?.totalCount ?? 0;

    _dataSource = ParticipantDataSource(
      participants,
      widget.workshop,
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
    final participants = widget.result?.result ?? [];

    if (isLoading && participants.isEmpty) {
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
            if (widget.workshop.workshopType == 'Children')
              DataColumn2(label: Text('Child Name')),
            DataColumn2(
              label: Text(
                widget.workshop.workshopType == "Children"
                    ? 'Parent Name'
                    : 'Participant Name',
              ),
            ),
            DataColumn2(label: Text('Email')),
            DataColumn2(label: Text('Attandance Status')),
            DataColumn2(label: Text('Registration Date')),
            DataColumn2(label: Text('Details')),
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

class ParticipantDataSource extends DataTableSource {
  final List<Participant> participants;
  final Workshop workshop;
  final BuildContext context;
  final int? count;
  final Future<void> Function(int page)? onPageChanged;
  final int pageSize;
  final int currentPage;

  ParticipantDataSource(
    this.participants,
    this.workshop,
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

    if (localIndex < 0 || localIndex >= participants.length) return null;

    final participant = participants[localIndex];

    return DataRow.byIndex(
      index: index,
      cells: [
        if (workshop.workshopType == 'Children')
          DataCell(
            Text(
              "${participant.child?.firstName} ${participant.child?.lastName}",
            ),
          ),
        DataCell(
          Text("${participant.user?.firstName} ${participant.user?.lastName}"),
        ),
        DataCell(Text(participant.user?.email ?? "")),
        DataCell(Text(participant.attendanceStatus.name ?? "")),
        DataCell(
          Text(
            DateFormat(
              'd. M. y.',
            ).format(participant.registrationDate).toString(),
          ),
        ),
        DataCell(
          PrimaryButton(
            onPressed: () {
              //todo
            },
            label: 'View Profile',
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => count ?? participants.length;

  @override
  int get selectedRowCount => 0;

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}
