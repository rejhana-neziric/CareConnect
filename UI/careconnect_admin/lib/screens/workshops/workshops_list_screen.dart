import 'package:careconnect_admin/core/layouts/master_screen.dart';
import 'package:careconnect_admin/models/enums/workshop_status.dart';
import 'package:careconnect_admin/models/responses/search_result.dart';
import 'package:careconnect_admin/models/responses/workshop.dart';
import 'package:careconnect_admin/models/responses/workshop_statistics.dart';
import 'package:careconnect_admin/providers/workshop_form_provider.dart';
import 'package:careconnect_admin/providers/workshop_provider.dart';
import 'package:careconnect_admin/screens/workshops/workshop_details_screen.dart';
import 'package:careconnect_admin/core/theme/app_colors.dart';
import 'package:careconnect_admin/widgets/confirm_dialog.dart';
import 'package:careconnect_admin/widgets/custom_dropdown_fliter.dart';
import 'package:careconnect_admin/widgets/no_results.dart';
import 'package:careconnect_admin/widgets/primary_button.dart';
import 'package:careconnect_admin/widgets/shimmer_stat_card.dart';
import 'package:careconnect_admin/widgets/snackbar.dart';
import 'package:careconnect_admin/widgets/stat_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WorkshopsListScreen extends StatefulWidget {
  const WorkshopsListScreen({super.key});

  @override
  State<WorkshopsListScreen> createState() => _WorkshopsListScreenState();
}

class _WorkshopsListScreenState extends State<WorkshopsListScreen> {
  late WorkshopProvider workshopProvider;

  SearchResult<Workshop>? workshops;
  int currentPage = 0;
  bool isLoading = false;

  final _ftsController = TextEditingController();
  final _priceController = TextEditingController();
  final _memberPriceController = TextEditingController();

  String? _sortBy;
  bool _sortAscending = true;

  String? selectedSortingOption;

  final Map<String, String?> sortingOptions = {
    'Not sorted': null,
    'Workshop Name': 'name',
    'Price': 'price',
    'Start Date': 'date',
    'Max Participants': 'maxParticipants',
    'Participants': 'participants',
  };

  String? selectedStatusOption;

  final Map<String, String?> statusOptions = {
    'All Status': null,
    'Draft': 'Draft',
    'Published': 'Published',
    'Canceled': 'Canceled',
    'Closed': 'Closed',
  };

  String? selectedWorkshopTypeOption;

  final Map<String, String?> workshopTypeOptions = {
    'All Types': null,
    'For Parents': 'Parents',
    'For Children': 'Children',
  };

  WorkshopStatistics? statistics;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    workshopProvider = context.read<WorkshopProvider>();
    loadData();
  }

  Future<SearchResult<Workshop>?> loadData() async {
    setState(() {
      isLoading = true;
    });

    final workshopProvider = Provider.of<WorkshopProvider>(
      context,
      listen: false,
    );

    final result = await workshopProvider.loadData(
      fts: _ftsController.text,
      nameGTE: null,
      status: selectedStatusOption,
      dateGTE: null,
      dateLTE: null,
      price: _priceController.text.isNotEmpty
          ? double.tryParse(_priceController.text)
          : null,
      maxParticipants: null,
      participants: null,
      workshopType: selectedWorkshopTypeOption,
      sortBy: _sortBy,
      sortAscending: _sortAscending,
    );

    workshops = result;

    loadStats();

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }

    return workshops;
  }

  Future<void> loadStats() async {
    final stats = await workshopProvider.loadStats();

    statistics = stats;

    if (mounted) {
      setState(() {});
    }
  }

  WorkshopStatus getStatus(String status) {
    return workshopStatusFromString(status);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MasterScreen(
      "Workshops",
      currentScreen: "Workshops",
      SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            _buildOverview(),
            _buildSearch(colorScheme),
            Consumer<WorkshopProvider>(
              builder: (context, workshopProvider, child) {
                return _buildResultView();
              },
            ),
          ],
        ),
      ),
      button: SizedBox(
        child: Align(
          alignment: Alignment.topRight,
          child: PrimaryButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider(
                    create: (_) => WorkshopFormProvider(),
                    child: WorkshopDetailsScreen(workshop: null),
                  ),
                ),
              );

              if (result == true) loadData();
            },
            label: 'Add Workshop',
          ),
        ),
      ),
    );
  }

  Widget _buildOverview() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 0.0,
        top: 0.0,
        right: 0.0,
        bottom: 32.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isLoading || statistics?.totalWorkshops == null
              ? shimmerStatCard(context)
              : statCard(
                  context,
                  'Total Workshops',
                  statistics?.totalWorkshops,
                  FontAwesomeIcons.puzzlePiece,
                  Colors.teal,
                  width: 300,
                ),

          SizedBox(width: 10),

          isLoading || statistics?.upcoming == null
              ? shimmerStatCard(context)
              : statCard(
                  context,
                  'Upcoming',
                  statistics?.upcoming == 0
                      ? 'No upcoming'
                      : statistics?.upcoming,
                  Icons.upcoming,
                  Colors.orange,
                  width: 300,
                ),

          SizedBox(width: 10),

          isLoading || statistics?.averageParticipants == null
              ? shimmerStatCard(context)
              : statCard(
                  context,
                  'Average Participants',
                  statistics?.averageParticipants,
                  Icons.people,
                  Colors.green,
                  width: 300,
                ),
        ],
      ),
    );
  }

  Widget _buildSearch(ColorScheme colorScheme) {
    return Row(
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 90.0,
              top: 0.0,
              right: 0.0,
              bottom: 0.0,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 600),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                  color: colorScheme.surfaceContainerLowest,
                ),
                child: TextField(
                  controller: _ftsController,
                  decoration: InputDecoration(
                    labelText: "Search Workshop Name...",
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerLowest,
                  ),
                  onChanged: (value) => loadData(),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 32),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 150),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
              color: colorScheme.surfaceContainerLowest,
            ),
            child: TextField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: "Price",
                border: InputBorder.none,
                filled: true,
                fillColor: colorScheme.surfaceContainerLowest,
              ),
              onChanged: (value) => loadData(),
            ),
          ),
        ),
        SizedBox(width: 32),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 250),
          child: Container(
            color: colorScheme.surfaceContainerLowest,
            width: 180,
            child: CustomDropdownFilter(
              selectedValue: selectedWorkshopTypeOption,
              options: workshopTypeOptions,
              name: "Type: ",
              onChanged: (newType) {
                setState(() {
                  selectedWorkshopTypeOption = newType;
                });
                loadData();
              },
            ),
          ),
        ),
        SizedBox(width: 32),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 250),
          child: Container(
            color: colorScheme.surfaceContainerLowest,
            width: 180,
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
        SizedBox(width: 32),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 200),
          child: Container(
            color: colorScheme.surfaceContainerLowest,
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
        ),
        SizedBox(width: 8),
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
            _ftsController.clear();
            _priceController.clear();
            _memberPriceController.clear();
            _sortBy = null;
            selectedSortingOption = null;
            selectedWorkshopTypeOption = null;
            selectedStatusOption = null;
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
        SizedBox(width: 32),
      ],
    );
  }

  Widget _buildResultView() {
    return (workshops != null && workshops?.result.isEmpty == false)
        ? GridView.count(
            crossAxisCount: 1,
            childAspectRatio: 350 / 100,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 256.0,
              vertical: 64.0,
            ),
            crossAxisSpacing: 64,
            mainAxisSpacing: 32,
            children: [...buildWorkshops(workshops!.result)],
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

  List<Widget> buildWorkshops(List<Workshop> workshops) {
    return workshops.map((item) => _buildWorkshop(item)).toList();
  }

  Widget _buildWorkshop(Workshop workshop) {
    return WorkshopCard(workshop: workshop, loadData: loadData);
  }
}

class WorkshopCard extends StatefulWidget {
  final Workshop workshop;
  final Future<SearchResult<Workshop>?> Function() loadData;

  const WorkshopCard({
    super.key,
    required this.workshop,
    required this.loadData,
  });

  @override
  State<WorkshopCard> createState() => _WorkshopCardState();
}

class _WorkshopCardState extends State<WorkshopCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    double screenWidth = MediaQuery.of(context).size.width;
    return Tooltip(
      message: "View workshop details.",
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: InkWell(
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider(
                  create: (_) => WorkshopFormProvider(),
                  child: WorkshopDetailsScreen(workshop: widget.workshop),
                ),
              ),
            );

            if (result == true) {
              widget.loadData();
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: screenWidth < 350 ? screenWidth * 0.95 : 300,
            // height: 150,
            child: Card(
              color: colorScheme.surfaceContainerLowest,
              margin: EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isHovered ? AppColors.mauveGray : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.workshop.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.mauveGray,
                            ),
                          ),

                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: workshopStatusFromString(
                                    widget.workshop.status,
                                  ).backgroundColor,
                                  border: null,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  workshopStatusFromString(
                                    widget.workshop.status,
                                  ).label,
                                  style: TextStyle(
                                    color: workshopStatusFromString(
                                      widget.workshop.status,
                                    ).textColor,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      widget.workshop.workshopType == "Parents"
                                      ? Color(0xFFFFE0D6)
                                      : Color(0xFFD0E8FF),
                                  border: null,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  widget.workshop.workshopType == "Parents"
                                      ? "Parents"
                                      : "Children",
                                  style: TextStyle(
                                    color:
                                        widget.workshop.workshopType ==
                                            "Parents"
                                        ? Color.fromARGB(255, 80, 80, 80)
                                        : Color.fromARGB(255, 80, 80, 80),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      if (widget.workshop.maxParticipants != null)
                        Row(
                          children: [
                            Icon(Icons.people),
                            SizedBox(width: 8),
                            Text(
                              "Max participant: ${widget.workshop.maxParticipants}",
                            ),
                          ],
                        ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.date_range),
                          SizedBox(width: 8),
                          Text(
                            DateFormat('d. M. y.').format(widget.workshop.date),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        widget.workshop.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              if (widget.workshop.price != null)
                                Container(
                                  decoration: BoxDecoration(
                                    color: colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "Price: ${widget.workshop.price}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              SizedBox(width: 15),
                              // if (widget.workshop.memberPrice != null)
                              //   Container(
                              //     decoration: BoxDecoration(
                              //       color: colorScheme.primaryContainer,

                              //       borderRadius: BorderRadius.circular(4),
                              //     ),
                              //     child: Padding(
                              //       padding: const EdgeInsets.all(4.0),
                              //       child: Text(
                              //         "Member price: ${widget.workshop.memberPrice}",
                              //         style: TextStyle(
                              //           fontWeight: FontWeight.w500,
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Edited: ${DateFormat('d. M. y.').format(widget.workshop.modifiedDate)}",
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: workshopStatusFromString(widget.workshop.status)
                            .allowedActions
                            .map(
                              (action) => Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: PrimaryButton(
                                  onPressed: () async {
                                    if (action != "View Participants") {
                                      final shouldProceed =
                                          await CustomConfirmDialog.show(
                                            context,
                                            icon: Icons.info,
                                            title: '$action Workshop',
                                            content:
                                                'Are you sure you want to $action this workshop?',
                                            confirmText: action,
                                            cancelText: 'Cancel',
                                          );

                                      if (shouldProceed != true) return;
                                    }

                                    final result =
                                        await Provider.of<WorkshopProvider>(
                                          context,
                                          listen: false,
                                        ).handleWorkshopAction(
                                          widget.workshop,
                                          action,
                                          context,
                                        );

                                    if (action != "View Participants") {
                                      CustomSnackbar.show(
                                        context,
                                        message: result
                                            ? 'Workshop successfully changed.'
                                            : 'Something went wrong. Please try again.',
                                        type: result
                                            ? SnackbarType.success
                                            : SnackbarType.error,
                                      );
                                    }

                                    if (result == true) widget.loadData();
                                  },

                                  label: action,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
