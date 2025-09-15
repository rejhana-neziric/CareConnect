import 'package:careconnect_mobile/models/responses/workshop.dart';
import 'package:careconnect_mobile/providers/utils.dart';
import 'package:careconnect_mobile/providers/workshop_provider.dart';
import 'package:careconnect_mobile/screens/workshop_details_screen.dart';
import 'package:careconnect_mobile/widgets/filter/filter_config.dart';
import 'package:careconnect_mobile/widgets/filter/filter_option.dart';
import 'package:careconnect_mobile/widgets/filter/filter_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkshopsListScreen extends StatefulWidget {
  const WorkshopsListScreen({super.key});

  @override
  State<WorkshopsListScreen> createState() => _WorkshopsListScreenState();
}

class _WorkshopsListScreenState extends State<WorkshopsListScreen> {
  bool isLoading = false;

  late WorkshopProvider workshopProvider;

  List<Workshop> workshops = [];

  Map<String, List<String>> appliedFilters = {};

  String? _sortBy;
  bool _sortAscending = true;

  final TextEditingController _searchController = TextEditingController();
  String? search;

  double? selectedPriceToFilter;

  String? selectedWorkshopType;

  @override
  void initState() {
    super.initState();

    workshopProvider = context.read<WorkshopProvider>();

    loadWorkshops();
  }

  Future<void> loadWorkshops() async {
    setState(() {
      isLoading = true;
    });

    final response = await workshopProvider.loadData(
      nameGTE: search,
      price: selectedPriceToFilter,
      sortBy: _sortBy,
      sortAscending: _sortAscending,
      status: 'Closed',
      workshopType: selectedWorkshopType,
    );

    setState(() {
      workshops = response?.result ?? [];
      isLoading = false;
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
                      hintText: "Search by workshop name...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      isDense: true,
                    ),
                    onChanged: (value) {
                      setState(() {
                        search = value;
                      });
                      loadWorkshops();
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

          Expanded(child: _buildWorkshops(colorScheme)),
        ],
      ),
    );
  }

  Widget _buildWorkshops(ColorScheme colorScheme) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (workshops.isEmpty) {
      return const Center(
        child: Text(
          "No current available workshops. Please check later.",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: workshops.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final workshop = workshops[index];
        return _buildWorkshopCard(workshop, colorScheme);
      },
    );
  }

  Widget _buildWorkshopCard(Workshop workshop, ColorScheme colorScheme) {
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        workshop.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: workshop.workshopType == "Parents"
                            ? Color(0xFFFFE0D6)
                            : Color(0xFFD0E8FF),
                        border: null,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        workshop.workshopType == "Parents"
                            ? "Parents"
                            : "Children",
                        style: TextStyle(
                          color: workshop.workshopType == "Parents"
                              ? Color.fromARGB(255, 80, 80, 80)
                              : Color.fromARGB(255, 80, 80, 80),
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                if (workshop.price != null)
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        "Price: ${workshop.price}",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),

                if (workshop.price == null)
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
                            WorkshopDetailsScreen(workshop: workshop),
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

  FilterConfig get workshopFilterConfig => FilterConfig(
    title: 'Filters',
    sections: [
      FilterSection(
        title: 'Workshop Type',
        allowMultipleSelection: false,
        options: _buildWorkshopTypeOptions(),
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
        label: 'Workshop Name',
        isSelected: _sortBy == 'name',
      ),
      FilterOption<String>(
        key: 'price',
        label: 'Price',
        isSelected: _sortBy == 'price',
      ),
    ];
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

  List<FilterOption> _buildWorkshopTypeOptions() {
    return [
      FilterOption<String>(
        key: 'all',
        label: 'All',
        isSelected: selectedWorkshopType == null,
      ),
      FilterOption<String>(
        key: 'parents',
        label: 'Parents',
        isSelected: selectedWorkshopType == 'Parents',
      ),
      FilterOption<String>(
        key: 'children',
        label: 'Children',
        isSelected: selectedWorkshopType == 'Children',
      ),
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
      config: workshopFilterConfig,
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

    loadWorkshops();
  }

  void _extractFilterValues(Map<String, List<String>> filters) {
    bool isFree = filters['price_free']?.contains('true') ?? false;
    String? selectedPrice;

    if (!isFree && filters['price'] != null && filters['price']!.isNotEmpty) {
      selectedPrice = filters['price']!.first;
    }

    if (filters['sort by'] != null) {
      _sortBy = filters['sort by']!.first;
    } else {
      _sortBy = null;
    }

    if (filters['workshop type'] != null &&
        filters['workshop type']!.first != 'all') {
      selectedWorkshopType = filters['workshop type']!.first;
    } else {
      selectedWorkshopType = null;
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

    loadWorkshops();
  }
}
