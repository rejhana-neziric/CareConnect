import 'package:careconnect_admin/layouts/master_screen.dart';
import 'package:careconnect_admin/models/responses/search_result.dart';
import 'package:careconnect_admin/models/responses/service.dart';
import 'package:careconnect_admin/models/responses/service_statistics.dart';
import 'package:careconnect_admin/providers/service_form_provider.dart';
import 'package:careconnect_admin/providers/service_provider.dart';
import 'package:careconnect_admin/screens/service_details_screen.dart';
import 'package:careconnect_admin/theme/app_colors.dart';
import 'package:careconnect_admin/widgets/custom_dropdown_fliter.dart';
import 'package:careconnect_admin/widgets/no_results.dart';
import 'package:careconnect_admin/widgets/primary_button.dart';
import 'package:careconnect_admin/widgets/stat_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ServicesListScreen extends StatefulWidget {
  const ServicesListScreen({super.key});

  @override
  State<ServicesListScreen> createState() => _ServicesListScreenState();
}

class _ServicesListScreenState extends State<ServicesListScreen> {
  late ServiceProvider serviceProvider;

  SearchResult<Service>? services;
  int currentPage = 0;

  final _ftsController = TextEditingController();
  final _priceController = TextEditingController();
  final _memberPriceController = TextEditingController();

  String? _sortBy;
  bool _sortAscending = true;

  String? selectedSortingOption;

  final Map<String, String?> sortingOptions = {
    'Not sorted': null,
    'Service Name': 'name',
    'Price': 'price',
    'Member Price': 'memberPrice',
  };

  String? selectedIsActiveOption;

  final Map<String, String?> isActiveOptions = {
    'All Status': null,
    'Active': 'true',
    'Inactive': 'false',
  };

  bool? isActive;

  ServiceStatistics? statistics;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    serviceProvider = context.read<ServiceProvider>();
    loadData();
  }

  Future<SearchResult<Service>?> loadData() async {
    final serviceProvider = Provider.of<ServiceProvider>(
      context,
      listen: false,
    );

    final result = await serviceProvider.loadData(
      fts: _ftsController.text,
      price: _priceController.text.isNotEmpty
          ? double.tryParse(_priceController.text)
          : null,
      memberPrice: _memberPriceController.text.isNotEmpty
          ? double.tryParse(_memberPriceController.text)
          : null,
      isActive: isActive,
      sortBy: _sortBy,
      sortAscending: _sortAscending,
    );

    services = result;

    loadStats();

    if (mounted) {
      setState(() {});
    }

    return services;
  }

  Future<void> loadStats() async {
    final stats = await serviceProvider.loadStats();

    statistics = stats;
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      "Services",
      SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            _buildOverview(),
            _buildSearch(),
            Consumer<ServiceProvider>(
              builder: (context, serviceProvider, child) {
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
                    create: (_) => ServiceFormProvider(),
                    child: ServiceDetailsScreen(service: null),
                  ),
                ),
              );

              if (result == true) loadData();
            },
            label: 'Add Service',
          ),
        ),
      ),
    );
  }

  Widget _buildOverview() {
    //todo: add list of most popular services
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
          statCard(
            context,
            'Total Services',
            statistics?.totalServices,
            Icons.groups,
            Colors.teal,
          ),
          SizedBox(width: 20),
          statCard(
            context,

            'Average Price',
            statistics?.averagePrice == null
                ? 0
                : statistics?.averagePrice?.round(),
            Icons.attach_money,
            Colors.green,
          ),
          SizedBox(width: 20),
          statCard(
            context,
            "Average Member Price",
            statistics?.averageMemberPrice == null
                ? 0
                : statistics?.averageMemberPrice?.round(),
            Icons.attach_money,
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
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
                  color: AppColors.white,
                ),
                child: TextField(
                  controller: _ftsController,
                  decoration: InputDecoration(
                    labelText: "Search Service Name...",
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
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
              color: AppColors.white,
            ),
            child: TextField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: "Price",
                border: InputBorder.none,
              ),
              onChanged: (value) => loadData(),
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
              color: AppColors.white,
            ),
            child: TextField(
              controller: _memberPriceController,
              decoration: InputDecoration(
                labelText: "Member Price",
                border: InputBorder.none,
              ),
              onChanged: (value) => loadData(),
            ),
          ),
        ),
        SizedBox(width: 32),

        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 250),
          child: Container(
            color: AppColors.white,
            width: 250,
            child: CustomDropdownFliter(
              selectedValue: selectedIsActiveOption,
              options: isActiveOptions,
              name: "Available Status: ",
              onChanged: (newStatus) {
                setState(() {
                  selectedIsActiveOption = newStatus;
                  if (newStatus == 'true') {
                    isActive = true;
                  } else if (newStatus == 'false') {
                    isActive = false;
                  } else {
                    isActive = null;
                  }
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
            color: AppColors.white,
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
        ),
        SizedBox(width: 8),
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
            _priceController.clear();
            _memberPriceController.clear();
            _sortBy = null;
            selectedSortingOption = null;
            selectedIsActiveOption = null;
            isActive = null;
            loadData();
          },
          label: Text("Refresh", style: TextStyle(color: Colors.black)),
          icon: Icon(Icons.refresh_outlined, color: Colors.black),
        ),
        SizedBox(width: 32),
      ],
    );
  }

  Widget _buildResultView() {
    return (services != null && services?.result.isEmpty == false)
        ? GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 450 / 150,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(64),
            crossAxisSpacing: 64,
            mainAxisSpacing: 32,
            children: [...buildServices(services!.result)],
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

  List<Widget> buildServices(List<Service> services) {
    return services.map((item) => _buildService(item)).toList();
  }

  Widget _buildService(Service service) {
    return ServiceCard(service: service, loadData: loadData);
  }
}

class ServiceCard extends StatefulWidget {
  final Service service;
  final Future<SearchResult<Service>?> Function() loadData;

  const ServiceCard({super.key, required this.service, required this.loadData});

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    double screenWidth = MediaQuery.of(context).size.width;
    return Tooltip(
      message: "Click to view service details.",
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: InkWell(
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider(
                  create: (_) => ServiceFormProvider(),
                  child: ServiceDetailsScreen(service: widget.service),
                ),
              ),
            );

            if (result == true) {
              widget.loadData();
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: screenWidth < 550 ? screenWidth * 0.95 : 500,
            height: 150,
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
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.service.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.mauveGray,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: widget.service.isActive == true
                                  ? const Color.fromRGBO(204, 245, 215, 1)
                                  : Colors.red.shade50,
                              border: null,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              widget.service.isActive == true
                                  ? "Active"
                                  : "Inactive",
                              style: TextStyle(
                                color: widget.service.isActive == true
                                    ? Color.fromARGB(255, 80, 80, 80)
                                    : Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        widget.service.description == null
                            ? "No description."
                            : "${widget.service.description}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              if (widget.service.price != null)
                                Container(
                                  decoration: BoxDecoration(
                                    color: colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "Price: ${widget.service.price}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              SizedBox(width: 15),
                              if (widget.service.memberPrice != null)
                                Container(
                                  decoration: BoxDecoration(
                                    color: colorScheme.primaryContainer,

                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      "Member price: ${widget.service.memberPrice}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          Text(
                            "Edited: ${DateFormat('d. M. y.').format(widget.service.modifiedDate)}",
                          ),
                        ],
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
