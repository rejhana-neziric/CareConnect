import 'package:careconnect_mobile/models/responses/search_result.dart';
import 'package:careconnect_mobile/models/responses/service.dart';
import 'package:careconnect_mobile/models/responses/service_type.dart';
import 'package:careconnect_mobile/providers/service_provider.dart';
import 'package:careconnect_mobile/providers/service_type_provider.dart';
import 'package:careconnect_mobile/providers/utils.dart';
import 'package:careconnect_mobile/screens/service_details_screen.dart';
import 'package:careconnect_mobile/widgets/filter/filter_config.dart';
import 'package:careconnect_mobile/widgets/filter/filter_option.dart';
import 'package:careconnect_mobile/widgets/filter/filter_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServicesListScreen extends StatefulWidget {
  const ServicesListScreen({super.key});

  @override
  State<ServicesListScreen> createState() => _ServicesListScreenState();
}

class _ServicesListScreenState extends State<ServicesListScreen> {
  bool isLoading = false;

  late ServiceProvider serviceProvider;
  late ServiceTypeProvider serviceTypeProvider;

  List<Service> services = [];

  Map<String, List<String>> appliedFilters = {};

  SearchResult<ServiceType>? serviceTypes;
  int? selectedServiceTypeId;
  List<FilterOption> serviceTypeOptions = [];

  String? _sortBy;
  bool _sortAscending = true;

  final TextEditingController _searchController = TextEditingController();
  String? serviceName;

  double? selectedPriceToFilter;

  @override
  void initState() {
    super.initState();

    serviceProvider = context.read<ServiceProvider>();
    serviceTypeProvider = context.read<ServiceTypeProvider>();

    loadServices();
    loadServiceTypes();
  }

  Future<void> loadServices() async {
    setState(() {
      isLoading = true;
    });

    final response = await serviceProvider.loadData(
      fts: serviceName,
      serviceTypeId: selectedServiceTypeId,
      price: selectedPriceToFilter,
      sortBy: _sortBy,
      sortAscending: _sortAscending,
    );

    setState(() {
      services = response?.result ?? [];
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
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
                      loadServices();
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

          Expanded(child: _buildServices(colorScheme)),
        ],
      ),
    );
  }

  Widget _buildServices(ColorScheme colorScheme) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (services.isEmpty) {
      return const Center(
        child: Text(
          "No services found.",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: services.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final service = services[index];
        return _buildServiceCard(service, colorScheme);
      },
    );
  }

  Widget _buildServiceCard(Service service, ColorScheme colorScheme) {
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
                  service.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 0,
                    ),
                    child: Text(
                      service.serviceType?.name ?? "",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                if (service.price != null)
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        "Price: ${service.price}",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),

                if (service.price == null)
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        "Price: FREE",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // const SizedBox(width: 8),
          SizedBox(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ServiceDetailsScreen(service: service),
                      ),
                    );
                  },
                  icon: const Icon(Icons.chevron_right, color: Colors.grey),
                  tooltip: "Open filters",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  FilterConfig get serviceFilterConfig => FilterConfig(
    title: 'Filters',
    sections: [
      FilterSection(
        title: 'Service Type',
        allowMultipleSelection: false,
        options: _buildServiceTypeOptions(),
      ),

      FilterSection(
        title: 'Price',
        allowMultipleSelection: false,
        isPrice: true,
        options: _buildPriceOptions(),
      ),

      FilterSection(
        title: 'Sort by',
        allowMultipleSelection: false,
        options: _buildSortByOptions(),
      ),

      FilterSection(
        title: 'Sort direction',
        allowMultipleSelection: false,
        options: _buildSortDirectionOptions(),
      ),
    ],
  );

  List<FilterOption<String>> _buildSortByOptions() {
    return [
      FilterOption<String>(
        key: 'notSorted',
        label: 'Not sorted',
        isSelected: _sortBy == null,
      ),
      FilterOption<String>(
        key: 'name',
        label: 'Service Name',
        isSelected: _sortBy == 'name',
      ),
      FilterOption<String>(
        key: 'price',
        label: 'Price',
        isSelected: _sortBy == 'price',
      ),
    ];
  }

  List<FilterOption<String>> _buildServiceTypeOptions() {
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

  List<FilterOption> _buildPriceOptions() {
    return [
      FilterOption(key: 'free', label: 'Free'),
      FilterOption(key: 'price_10', label: '\$10'),
      FilterOption(key: 'price_20', label: '\$20'),
      FilterOption(key: 'price_30', label: '\$30'),
      FilterOption(key: 'price_40', label: '\$40'),
      FilterOption(key: 'price_50', label: '\$50'),
      FilterOption(key: 'price_60', label: '\$60'),
      FilterOption(key: 'price_70', label: '\$70'),
      FilterOption(key: 'price_80', label: '\$80'),
      FilterOption(key: 'price_90', label: '\$90'),
      FilterOption(key: 'price_100', label: '\$100'),
    ];
  }

  List<FilterOption<String>> _buildSortDirectionOptions() {
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

  String getFirstFilterValue(String filterKey) {
    final values = appliedFilters[filterKey];
    return values != null && values.isNotEmpty ? values.first : '';
  }

  List<String> getValues(String filterKey) {
    final values = appliedFilters[filterKey];
    return values != null && values.isNotEmpty ? values : [];
  }

  void _showFilters() {
    showGenericFilter(
      context: context,
      config: serviceFilterConfig,
      onApply: _handleFilterApply,
      onClearAll: _handleClearAll,
      initialFilters: appliedFilters,
    );
  }

  void _handleFilterApply(Map<String, List<String>> filters) {
    setState(() {
      appliedFilters = Map.from(filters);
    });

    _extractFilterValues(filters);

    loadServices();
  }

  void _extractFilterValues(Map<String, List<String>> filters) {
    bool isFree = filters['price_free']?.contains('true') ?? false;
    String? selectedPrice;

    if (!isFree && filters['price'] != null && filters['price']!.isNotEmpty) {
      selectedPrice = filters['price']!.first;
    }

    if (filters['service type'] != null) {
      selectedServiceTypeId =
          filters['service type']!.isNotEmpty &&
              filters['service type'] != 'all'
          ? int.tryParse(filters['service type']![0])
          : null;
    } else {
      selectedServiceTypeId = null;
    }

    if (filters['sort by'] != null) {
      _sortBy = filters['sort by']!.first;
    } else {
      _sortBy = null;
    }

    if (filters['sort direction'] != null) {
      _sortAscending = filters['sort direction']!.first == 'asc' ? true : false;
    }

    if (isFree) {
      selectedPriceToFilter = 0;
    } else if (selectedPrice != null) {
      int priceValue = int.parse(selectedPrice);
      selectedPriceToFilter = priceValue.toDouble();
    } else {
      selectedPriceToFilter = null;
    }
  }

  void _handleClearAll() {
    setState(() {
      appliedFilters.clear();
    });

    loadServices();
  }
}
