import 'package:careconnect_admin/layouts/master_screen.dart';
import 'package:careconnect_admin/models/responses/search_result.dart';
import 'package:careconnect_admin/models/responses/service.dart';
import 'package:careconnect_admin/models/responses/service_statistics.dart';
import 'package:careconnect_admin/models/search_objects/service_search_object.dart';
import 'package:careconnect_admin/providers/service_provider.dart';
import 'package:careconnect_admin/screens/service_details_screen.dart';
import 'package:careconnect_admin/theme/app_colors.dart';
import 'package:careconnect_admin/widgets/custom_dropdown_fliter.dart';
import 'package:careconnect_admin/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

  ServiceStatistics? statistics;

  @override
  void initState() {
    super.initState();

    serviceProvider = context.read<ServiceProvider>();

    loadData();

    if (serviceProvider.shouldRefresh) {
      loadData();
      serviceProvider.markRefreshed();
    }
  }

  Future<SearchResult<Service>?> loadData({int page = 0}) async {
    final filterObject = ServiceSearchObject(
      nameGTE: _ftsController.text,
      price: _priceController.text.isEmpty != true
          ? double.parse(_priceController.text)
          : null,
      memberPrice: _memberPriceController.text.isEmpty != true
          ? double.parse(_memberPriceController.text)
          : null,
      page: page,
      sortBy: _sortBy,
      sortAscending: _sortAscending,
      includeTotalCount: true,
      retrieveAll: true,
    );

    final filter = filterObject.toJson();

    final result = await serviceProvider.get(filter: filter);

    services = result;

    final stats = await serviceProvider.getStatistics();

    statistics = stats;

    print(services);

    if (mounted) {
      setState(() {});
    }

    return services;
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      "Services",
      SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [_buildOverview(), _buildSearch(), _buildResultView()],
        ),
      ),
      button: SizedBox(
        child: Align(
          alignment: Alignment.topRight,
          child: PrimaryButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ServiceDetailsScreen(service: null),
                ),
              );
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
          _buildStatCard(
            'Total Services',
            statistics?.totalServices,
            Icons.groups,
            Colors.teal,
          ),
          SizedBox(width: 20),
          _buildStatCard(
            'Average Price',
            statistics?.averagePrice == null
                ? 0
                : statistics?.averagePrice?.round(),
            Icons.attach_money,
            Colors.green,
          ),
          SizedBox(width: 20),
          _buildStatCard(
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

  Widget _buildStatCard(
    String label,
    dynamic value,
    IconData icon,
    Color iconColor,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1.5,
      color: AppColors.white,
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
          constraints: BoxConstraints(maxWidth: 200),
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
          constraints: BoxConstraints(maxWidth: 200),
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
            loadData();
          },
          label: Text("Refresh", style: TextStyle(color: Colors.black)),
          icon: Icon(Icons.refresh_outlined, color: Colors.black),
        ),
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
                  icon: Icons.search_off,
                ),
              ],
            ),
          );
  }

  List<Widget> buildServices(List<Service> services) {
    return services.map((item) => _buildService(item)).toList();
  }

  Widget _buildService(Service service) {
    return ServiceCard(service: service);
  }
}

class ServiceCard extends StatefulWidget {
  final Service service;

  const ServiceCard({super.key, required this.service});

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Tooltip(
      message: "Click to view service details.",
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ServiceDetailsScreen(service: widget.service),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12), // optional
          child: Container(
            width: screenWidth < 550 ? screenWidth * 0.95 : 500,
            height: 150,
            child: Card(
              margin: EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isHovered ? AppColors.mauveGray : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.service.name}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.mauveGray,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "${widget.service.description}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.dustyRose,
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
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.dustyRose,
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

class NoResultsWidget extends StatelessWidget {
  final String message;
  final IconData icon;

  const NoResultsWidget({
    Key? key,
    this.message = 'No results found',
    this.icon = Icons.search_off,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
