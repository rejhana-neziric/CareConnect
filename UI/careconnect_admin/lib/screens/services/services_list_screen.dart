import 'package:careconnect_admin/core/layouts/master_screen.dart';
import 'package:careconnect_admin/models/responses/search_result.dart';
import 'package:careconnect_admin/models/responses/service.dart';
import 'package:careconnect_admin/models/responses/service_statistics.dart';
import 'package:careconnect_admin/models/responses/service_type.dart';
import 'package:careconnect_admin/providers/service_form_provider.dart';
import 'package:careconnect_admin/providers/service_provider.dart';
import 'package:careconnect_admin/providers/service_type_from_provider.dart';
import 'package:careconnect_admin/providers/service_type_provider.dart';
import 'package:careconnect_admin/screens/services/service_details_screen.dart';
import 'package:careconnect_admin/core/theme/app_colors.dart';
import 'package:careconnect_admin/widgets/confirm_dialog.dart';
import 'package:careconnect_admin/widgets/custom_dropdown_fliter.dart';
import 'package:careconnect_admin/widgets/custom_text_field.dart';
import 'package:careconnect_admin/widgets/no_results.dart';
import 'package:careconnect_admin/widgets/primary_button.dart';
import 'package:careconnect_admin/widgets/shimmer_stat_card.dart';
import 'package:careconnect_admin/widgets/snackbar.dart';
import 'package:careconnect_admin/widgets/stat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ServicesListScreen extends StatefulWidget {
  const ServicesListScreen({super.key});

  @override
  State<ServicesListScreen> createState() => _ServicesListScreenState();
}

class _ServicesListScreenState extends State<ServicesListScreen> {
  late ServiceProvider serviceProvider;
  late ServiceTypeProvider serviceTypeProvider;
  late ServiceTypeFromProvider serviceTypeFromProvider;

  bool isLoading = false;

  SearchResult<Service>? services;
  int currentPage = 0;

  SearchResult<ServiceType>? serviceTypes;
  ServiceType? selectedServiceType;
  Map<String, String?> serviceTypeOptions = {};

  final _ftsController = TextEditingController();
  final _priceController = TextEditingController();

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
    serviceTypeProvider = context.read<ServiceTypeProvider>();
    serviceTypeFromProvider = context.read<ServiceTypeFromProvider>();
    loadData();
  }

  Future<SearchResult<Service>?> loadData() async {
    setState(() {
      isLoading = true;
    });
    final serviceProvider = Provider.of<ServiceProvider>(
      context,
      listen: false,
    );

    final result = await serviceProvider.loadData(
      fts: _ftsController.text,
      price: _priceController.text.isNotEmpty
          ? double.tryParse(_priceController.text)
          : null,

      isActive: isActive,
      serviceTypeId: selectedServiceType?.serviceTypeId,
      sortBy: _sortBy,
      sortAscending: _sortAscending,
    );

    services = result;

    loadStats();
    loadServiceTypes();

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }

    return services;
  }

  Future<void> loadStats() async {
    final stats = await serviceProvider.loadStats();

    statistics = stats;
  }

  Future<void> loadServiceTypes() async {
    final result = await serviceTypeProvider.loadData();

    setState(() {
      serviceTypes = result;

      if (serviceTypes != null) {
        serviceTypeOptions = {
          'All': null,
          for (final type in serviceTypes!.result) type.name: type.name,
        };
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MasterScreen(
      "Services",
      currentScreen: "Services",
      Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildOverview(),
                  _buildSearch(colorScheme),
                  Consumer<ServiceProvider>(
                    builder: (context, serviceProvider, child) {
                      return _buildResultView();
                    },
                  ),
                ],
              ),
            ),
          ),
          Consumer<ServiceTypeProvider>(
            builder: (context, serviceTypeProvider, child) {
              return _buildServiceTypesList(colorScheme);
            },
          ),
        ],
      ),

      button: SizedBox(
        child: Align(
          alignment: Alignment.topRight,
          child: PrimaryButton(
            onPressed: () async {
              final selectedType = await showServiceTypeDialog(
                context,
                serviceTypes!.result,
              );

              if (selectedType != null) {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                      create: (_) => ServiceFormProvider(),
                      child: ServiceDetailsScreen(
                        service: null,
                        serviceTypeId: selectedType,
                      ),
                    ),
                  ),
                );

                if (result == true) loadData();
              }
            },
            label: 'Add Service',
          ),
        ),
      ),
    );
  }

  Future<int?> showServiceTypeDialog(
    BuildContext context,
    List<ServiceType> serviceTypes,
  ) async {
    int? selectedTypeId;

    return showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text("Choose Service Type"),
          content: StatefulBuilder(
            builder: (context, setState) {
              return DropdownButton<int>(
                isExpanded: true,
                hint: const Text("Select service type"),
                value: selectedTypeId,
                items: serviceTypes
                    .map(
                      (type) => DropdownMenuItem<int>(
                        value: type.serviceTypeId,
                        child: Text(type.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedTypeId = value;
                  });
                },
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text("Cancel"),
            ),
            PrimaryButton(
              onPressed: () {
                if (selectedTypeId != null) {
                  Navigator.of(context).pop(selectedTypeId);
                }
              },
              label: "Continue",
            ),
          ],
        );
      },
    );
  }

  Widget _buildServiceTypesList(ColorScheme colorScheme) {
    return SizedBox(
      width: 280,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Service Types",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: colorScheme.primaryContainer,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    initServiceTypeForm(null);
                  });
                  showAddServiceTypeDialog(context, null);
                },
                icon: Icon(Icons.add),
                tooltip: "Add Service Type",
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: serviceTypes?.result.length,
              itemBuilder: (context, index) {
                final type = serviceTypes?.result[index];
                bool isHovered = false;

                return StatefulBuilder(
                  builder: (context, setHoverState) {
                    return MouseRegion(
                      onEnter: (_) => setHoverState(() => isHovered = true),
                      onExit: (_) => setHoverState(() => isHovered = false),
                      child: Tooltip(
                        message: "View service type details",
                        child: GestureDetector(
                          onTap: () {
                            initServiceTypeForm(type);
                            showAddServiceTypeDialog(context, type);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isHovered
                                  ? colorScheme.secondaryContainer
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),

                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: ListTile(
                              title: Text(
                                "${type?.name ?? ""} (${type?.numberOfServices ?? "0"})",
                                style: TextStyle(
                                  color: colorScheme.onSecondaryContainer,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
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
          isLoading || statistics?.totalServices == null
              ? shimmerStatCard(context)
              : statCard(
                  context,
                  'Total Services',
                  statistics?.totalServices,
                  Icons.groups,
                  Colors.teal,
                ),

          SizedBox(width: 20),

          isLoading || statistics?.averagePrice == null
              ? shimmerStatCard(context)
              : statCard(
                  context,
                  'Average Price',
                  statistics?.averagePrice?.round(),
                  Icons.attach_money,
                  Colors.green,
                ),

          SizedBox(width: 20),

          isLoading || statistics?.averageMemberPrice == null
              ? shimmerStatCard(context)
              : statCard(
                  context,
                  "Average Member Price",
                  statistics?.averageMemberPrice?.round(),
                  Icons.attach_money,
                  Colors.orange,
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
              left: 30.0,
              top: 0.0,
              right: 0.0,
              bottom: 0.0,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 600),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                  color: colorScheme.surfaceContainerLowest,
                ),
                child: TextField(
                  controller: _ftsController,
                  decoration: InputDecoration(
                    labelText: "Search Service Name...",
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                    fillColor: colorScheme.surfaceContainerLowest,
                    filled: true,
                    labelStyle: TextStyle(fontSize: 15),
                  ),
                  onChanged: (value) => loadData(),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 8),
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
                fillColor: colorScheme.surfaceContainerLowest,
                filled: true,
                labelStyle: TextStyle(fontSize: 15),
              ),
              onChanged: (value) => loadData(),
            ),
          ),
        ),
        SizedBox(width: 8),
        SizedBox(
          width: 280,
          child: CustomDropdownFilter(
            selectedValue: selectedServiceType?.name,
            options: serviceTypeOptions,
            name: "Service Type: ",
            onChanged: (newType) {
              setState(() {
                final idx = serviceTypes?.result.indexWhere(
                  (s) => s.name == newType,
                );
                selectedServiceType = idx == -1
                    ? null
                    : serviceTypes?.result[idx!];
              });
              loadData();
            },
          ),
        ),
        SizedBox(width: 8),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 250),
          child: Container(
            color: colorScheme.surfaceContainerLowest,
            width: 180,
            child: CustomDropdownFilter(
              selectedValue: selectedIsActiveOption,
              options: isActiveOptions,
              name: "Status: ",
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
        SizedBox(width: 8),
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
            _sortBy = null;
            selectedSortingOption = null;
            selectedIsActiveOption = null;
            selectedServiceType = null;
            isActive = null;
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
    return (services != null && services?.result.isEmpty == false)
        ? GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 450 / 200,
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

  Future<void> showAddServiceTypeDialog(
    BuildContext context,
    ServiceType? serviceType,
  ) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final serviceTypeFromProvider = context.read<ServiceTypeFromProvider>();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: serviceType == null
              ? Text("Add Sercice Type")
              : Text("Edit Service Type"),
          content: FormBuilder(
            key: serviceTypeFromProvider.formKey,
            initialValue: _initialValue,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  width: 400,
                  name: "name",
                  label: "Name",
                  required: true,
                  validator:
                      serviceTypeFromProvider.validateServicWorkshopeName,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  width: 400,
                  name: "description",
                  label: "Description",
                  maxLines: 5,
                  hintText: 'Write a short and clear description...',
                  validator: serviceTypeFromProvider.validateDescription,
                ),
              ],
            ),
          ),
          actions: [
            if (serviceType != null)
              PrimaryButton(
                onPressed: () async {
                  final result = deleteServiceType(serviceType);

                  if (result == true) {
                    loadServiceTypes();
                    loadData();
                  }
                },
                label: 'Delete',
                backgroundColor: colorScheme.error,
              ),
            SizedBox(width: 130),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                PrimaryButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  label: 'Cancel',
                ),
                SizedBox(width: 10),
                PrimaryButton(
                  onPressed: () async {
                    final result = saveServiceType(serviceType);

                    if (result == true) {
                      loadServiceTypes();
                      loadData();
                    }
                  },
                  label: 'Save',
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Map<String, dynamic> _initialValue = {};
  // bool isLoading = true;

  Future<void> initServiceTypeForm(ServiceType? serviceType) async {
    setState(() {
      isLoading = true;
    });

    if (serviceType == null) {
      serviceTypeFromProvider.setForInsert();
    } else {
      serviceTypeFromProvider.setForUpdate({
        "name": serviceType.name,
        "description": serviceType.description,
      });
    }

    setState(() {
      _initialValue = Map<String, dynamic>.from(
        serviceTypeFromProvider.initialData,
      );
      isLoading = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (serviceTypeFromProvider.formKey.currentState != null) {
        serviceTypeFromProvider.formKey.currentState!.patchValue(_initialValue);
      }
    });

    setState(() {
      isLoading = false;
    });
  }

  Future<bool> deleteServiceType(ServiceType serviceType) async {
    final id = serviceType.serviceTypeId;

    if (serviceType.numberOfServices == null ||
        serviceType.numberOfServices == 0) {
      final shouldProceed = await CustomConfirmDialog.show(
        context,
        icon: Icons.info,

        title: 'Delete Service Type',
        content: 'Are you sure you want to delete this service type?',
        confirmText: 'Delete',
        cancelText: 'Cancel',
      );

      if (shouldProceed != true) return false;

      final success = await serviceTypeProvider.delete(id);

      if (!mounted) return false;

      CustomSnackbar.show(
        context,
        message: success
            ? 'Service type successfully deleted.'
            : 'Something went wrong. Please try again.',
        type: success ? SnackbarType.success : SnackbarType.error,
      );

      if (success) {
        Navigator.of(context).pop();
      }

      return success;
    } else {
      await CustomConfirmDialog.show(
        context,
        icon: Icons.info,
        title: 'Unable to delete',
        content:
            'This service type cannot be deleted because ${serviceType.numberOfServices} services are still using it.',
        confirmText: 'OK',
      );

      return false;
    }
  }

  Future<bool> saveServiceType(ServiceType? serviceType) async {
    final formState = serviceTypeFromProvider.formKey.currentState;

    if (formState == null || !formState.saveAndValidate()) {
      debugPrint('Form is not valid or state is null');
      return false;
    }

    final id = serviceType?.serviceTypeId;
    final isInsert = serviceType == null;

    final shouldProceed = await CustomConfirmDialog.show(
      context,
      icon: Icons.info,
      iconBackgroundColor: AppColors.mauveGray,
      title: isInsert ? 'Add New Service' : 'Save Changes',
      content: isInsert
          ? 'Are you sure you want to add a new service?'
          : 'Are you sure you want to save the service?',
      confirmText: 'Continue',
      cancelText: 'Cancel',
    );

    if (shouldProceed != true) return false;

    final success = await serviceTypeFromProvider.saveOrUpdate(
      serviceTypeFromProvider,
      serviceTypeProvider,
      id,
    );

    if (!mounted) return false;

    CustomSnackbar.show(
      context,
      message: success
          ? (serviceTypeFromProvider.isUpdate
                ? 'Service type updated.'
                : 'Service type added.')
          : 'Something went wrong. Please try again.',
      type: success ? SnackbarType.success : SnackbarType.error,
    );

    if (success && !serviceTypeFromProvider.isUpdate) {
      setState(() {});
      serviceTypeFromProvider.resetForm();
    }

    if (success) {
      serviceTypeFromProvider.saveInitialValue();
    }
    serviceTypeFromProvider.success = success;

    Navigator.of(context).pop();

    return success;
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
      message: "View service details.",
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
                          Expanded(
                            child: Text(
                              widget.service.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.mauveGray,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
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
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Text(
                            widget.service.serviceType?.name ?? "",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
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
