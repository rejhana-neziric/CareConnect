import 'package:careconnect_admin/layouts/master_screen.dart';
import 'package:careconnect_admin/models/responses/search_result.dart';
import 'package:careconnect_admin/models/responses/service.dart';
import 'package:careconnect_admin/models/responses/service_type.dart';
import 'package:careconnect_admin/providers/service_form_provider.dart';
import 'package:careconnect_admin/providers/service_provider.dart';
import 'package:careconnect_admin/providers/service_type_provider.dart';
import 'package:careconnect_admin/theme/app_colors.dart';
import 'package:careconnect_admin/utils.dart';
import 'package:careconnect_admin/widgets/confirm_dialog.dart';
import 'package:careconnect_admin/widgets/custom_date_field.dart';
import 'package:careconnect_admin/widgets/custom_dropdown_field.dart';
import 'package:careconnect_admin/widgets/custom_text_field.dart';
import 'package:careconnect_admin/widgets/primary_button.dart';
import 'package:careconnect_admin/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final Service? service;
  final int? serviceTypeId;

  const ServiceDetailsScreen({super.key, this.service, this.serviceTypeId});

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  Map<String, dynamic> _initialValue = {};
  SearchResult<Service>? result;
  late ServiceProvider serviceProvider;
  late ServiceFormProvider serviceFormProvider;
  late ServiceTypeProvider serviceTypeProvider;
  bool isLoading = true;
  List<ServiceType> serviceTypes = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    serviceProvider = context.read<ServiceProvider>();
    serviceFormProvider = context.read<ServiceFormProvider>();
    serviceTypeProvider = context.read<ServiceTypeProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initForm();
    });
  }

  Future<void> initForm() async {
    if (widget.service == null) {
      serviceFormProvider.setForInsert();
    } else {
      serviceFormProvider.setForUpdate({
        "name": widget.service?.name,
        "description": widget.service?.description,
        "price": widget.service?.price == null
            ? ""
            : widget.service?.price.toString(),
        "memberPrice": widget.service?.memberPrice == null
            ? ""
            : widget.service?.memberPrice.toString(),
        "isActive": widget.service?.isActive,
        "modifiedDate": widget.service?.modifiedDate,
        "serviceTypeId": widget.service == null
            ? widget.serviceTypeId
            : widget.service?.serviceTypeId,
      });
    }

    setState(() {
      _initialValue = Map<String, dynamic>.from(
        serviceFormProvider.initialData,
      );
      isLoading = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (serviceFormProvider.formKey.currentState != null) {
        serviceFormProvider.formKey.currentState!.patchValue(_initialValue);
      }
    });

    print(widget.serviceTypeId);

    loadServiceTypes();

    setState(() {});
  }

  Future<void> loadServiceTypes() async {
    final result = await serviceTypeProvider.loadData();

    setState(() {
      serviceTypes = result?.result ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      "Service Details",
      SingleChildScrollView(
        padding: const EdgeInsets.all(64),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (!isLoading) _buildForm(),
                    const SizedBox(height: 20),
                    _actionButtons(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      onBackPressed: () => serviceFormProvider.handleBackPressed(context),
    );
  }

  Widget _buildForm() {
    final serviceFormProvider = Provider.of<ServiceFormProvider>(context);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return FormBuilder(
      key: serviceFormProvider.formKey,
      autovalidateMode: AutovalidateMode.disabled,
      initialValue: _initialValue,
      onChanged: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (serviceFormProvider.isUpdate)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [buildSectionTitle("Edit service", colorScheme)],
            ),
          if (!serviceFormProvider.isUpdate)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [buildSectionTitle("Add new service", colorScheme)],
            ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      width: 600,
                      name: 'name',
                      label: 'Service Name',
                      validator: (value) => serviceFormProvider
                          .validateServicWorkshopeName(value),
                      required: true,
                    ),
                    // CustomTextField(
                    //   width: 600,
                    //   name: 'serviceTypeId',
                    //   label: 'Service Type',
                    //   // validator: (value) => serviceFormProvider
                    //   //     .validateServicWorkshopeName(value),
                    //   required: true,
                    // ),
                    if (widget.service != null)
                      CustomDropdownField<int>(
                        width: 600,
                        name: 'serviceTypeId',
                        label: 'Service Type',
                        items: buildServiceTypeItems(serviceTypes),
                        // initialValue: currentService
                        //     .serviceTypeId, // Make sure this matches one of the item values
                        required: true,
                        validator: (value) {
                          if (value == null) return 'Service type is required';
                          return null;
                        },
                      ),
                    // buildServiceTypeDropdown(
                    //   serviceTypes: serviceTypes,
                    //   service: widget.service!,
                    // ),
                    CustomTextField(
                      width: 600,
                      name: 'description',
                      label: 'Description',
                      maxLines: 5,
                      hintText: 'Write a short and clear description...',
                      validator: serviceFormProvider.validateDescription,
                    ),
                    CustomTextField(
                      width: 600,
                      name: 'price',
                      label: 'Price',
                      validator: serviceFormProvider.validatePrice,
                    ),
                    CustomTextField(
                      width: 600,
                      name: 'memberPrice',
                      label: 'Member Price',
                      validator: serviceFormProvider.validatePrice,
                    ),
                    CustomDropdownField<bool>(
                      width: 600,
                      name: 'isActive',
                      label: 'Availability',
                      items: [
                        DropdownMenuItem(value: true, child: Text('Active')),
                        DropdownMenuItem(value: false, child: Text('Inactive')),
                      ],
                      validator: serviceFormProvider.validateNonEmptyBool,
                    ),
                    if (serviceFormProvider.isUpdate)
                      CustomDateField(
                        width: 600,
                        name: 'modifiedDate',
                        label: 'Last Edited',
                        enabled: false,
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 40, height: 80),
        ],
      ),
    );
  }

  List<DropdownMenuItem<int>> buildServiceTypeItems(
    List<ServiceType> serviceTypes,
  ) {
    return serviceTypes.map((serviceType) {
      return DropdownMenuItem<int>(
        value: serviceType
            .serviceTypeId, // This should be the actual ID from your model
        child: Text(serviceType.name), // This is what gets displayed
      );
    }).toList();
  }

  // Widget buildServiceTypeDropdown({
  //   required List<ServiceType> serviceTypes,
  //   required Service service,
  // }) {
  //   return CustomDropdownField<int>(
  //     width: 400,
  //     name: "serviceTypeId",
  //     label: "Service Type",
  //     required: true,

  //     items: serviceTypes.map((type) {
  //       return DropdownMenuItem<int>(
  //         value: type.serviceTypeId,
  //         child: Text(type.name),
  //       );
  //     }).toList(),

  //     initialValue: serviceTypes.indexWhere(
  //       (type) => type.serviceTypeId == service.serviceTypeId,
  //     ),
  //     validator: (value) {
  //       if (value == null) return "Please select a service type";
  //       return null;
  //     },
  //   );
  // }

  Widget _actionButtons() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: 600,
      child: Row(
        children: [
          if (widget.service != null)
            PrimaryButton(
              onPressed: () async {
                delete();
              },
              label: 'Delete',
              backgroundColor: colorScheme.error,
            ),

          Spacer(),
          Row(
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
                  save();
                },
                label: 'Save',
              ),
            ],
          ),
        ],
      ),
    );
  }

  void delete() async {
    final id = widget.service?.serviceId;

    final shouldProceed = await CustomConfirmDialog.show(
      context,
      icon: Icons.info,

      title: 'Delete Service',
      content: 'Are you sure you want to delete this service?',
      confirmText: 'Delete',
      cancelText: 'Cancel',
    );

    if (shouldProceed != true) return;

    final success = await serviceProvider.delete(id!);

    if (!mounted) return;

    CustomSnackbar.show(
      context,
      message: success
          ? 'Service successfully deleted.'
          : 'Something went wrong. Please try again.',
      type: success ? SnackbarType.success : SnackbarType.error,
    );

    if (success) {
      Navigator.of(context).pop();
    }
  }

  void save() async {
    final formState = serviceFormProvider.formKey.currentState;

    if (formState == null || !formState.saveAndValidate()) {
      debugPrint('Form is not valid or state is null');
      return;
    }

    final id = widget.service?.serviceId;
    final isInsert = widget.service == null;

    if (isInsert) {
      // final formData = Map<String, dynamic>.from(formState.value);
      // formData['serviceTypeId'] = widget.serviceTypeId;

      formState.setInternalFieldValue('serviceTypeId', widget.serviceTypeId);

      formState.save();
    }

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

    if (shouldProceed != true) return;

    final success = await serviceFormProvider.saveOrUpdate(
      serviceFormProvider,
      serviceProvider,
      id,
    );

    if (!mounted) return;

    CustomSnackbar.show(
      context,
      message: success
          ? (serviceFormProvider.isUpdate
                ? 'Service updated.'
                : 'Service added.')
          : 'Something went wrong. Please try again.',
      type: success ? SnackbarType.success : SnackbarType.error,
    );

    if (success && !serviceFormProvider.isUpdate) {
      setState(() {});
      serviceFormProvider.resetForm();
    }

    if (success) {
      serviceFormProvider.saveInitialValue();
    }
    serviceFormProvider.success = success;
  }
}
