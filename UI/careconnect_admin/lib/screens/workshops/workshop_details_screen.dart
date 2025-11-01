import 'package:careconnect_admin/core/layouts/master_screen.dart';
import 'package:careconnect_admin/models/enums/workshop_status.dart';
import 'package:careconnect_admin/models/responses/search_result.dart';
import 'package:careconnect_admin/models/responses/workshop.dart';
import 'package:careconnect_admin/models/workshopML/workshop_prediction.dart';
import 'package:careconnect_admin/providers/permission_provider.dart';
import 'package:careconnect_admin/providers/workshop_form_provider.dart';
import 'package:careconnect_admin/providers/workshop_provider.dart';
import 'package:careconnect_admin/core/theme/app_colors.dart';
import 'package:careconnect_admin/core/utils.dart';
import 'package:careconnect_admin/screens/no_permission_screen.dart';
import 'package:careconnect_admin/widgets/confirm_dialog.dart';
import 'package:careconnect_admin/widgets/custom_date_field.dart';
import 'package:careconnect_admin/widgets/custom_dropdown_field.dart';
import 'package:careconnect_admin/widgets/custom_text_field.dart';
import 'package:careconnect_admin/widgets/primary_button.dart';
import 'package:careconnect_admin/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class WorkshopDetailsScreen extends StatefulWidget {
  final Workshop? workshop;

  const WorkshopDetailsScreen({super.key, this.workshop});

  @override
  State<WorkshopDetailsScreen> createState() => _WorkshopDetailsScreenState();
}

class _WorkshopDetailsScreenState extends State<WorkshopDetailsScreen> {
  Map<String, dynamic> _initialValue = {};
  SearchResult<Workshop>? result;
  late WorkshopProvider workshopProvider;
  late WorkshopFormProvider workshopFormProvider;
  bool isLoading = true;
  Workshop? _currentWorkshop;

  WorkshopPrediction? _prediction;
  bool isLoadingPrediction = false;
  String? _errorMessage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    workshopProvider = context.read<WorkshopProvider>();
    workshopFormProvider = context.read<WorkshopFormProvider>();
    _currentWorkshop = widget.workshop;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initForm();
    });
  }

  Future<void> initForm() async {
    if (_currentWorkshop == null) {
      workshopFormProvider.setForInsert();
    } else {
      workshopFormProvider.setForUpdate({
        "name": _currentWorkshop?.name,
        "status": _currentWorkshop?.status,
        "description": _currentWorkshop?.description,
        "workshopType": _currentWorkshop?.workshopType,
        "date": _currentWorkshop?.date,
        "price": _currentWorkshop?.price == null
            ? ""
            : _currentWorkshop?.price.toString(),
        "maxParticipants": _currentWorkshop?.maxParticipants == null
            ? ""
            : _currentWorkshop?.maxParticipants.toString(),
        "participants": _currentWorkshop?.participants == null
            ? ""
            : _currentWorkshop?.participants.toString(),
        "modifiedDate": _currentWorkshop?.modifiedDate,
        "notes": _currentWorkshop?.notes ?? "No notes",
      });
    }

    setState(() {
      _initialValue = Map<String, dynamic>.from(
        workshopFormProvider.initialData,
      );
      isLoading = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (workshopFormProvider.formKey.currentState != null) {
        workshopFormProvider.formKey.currentState!.patchValue(_initialValue);
      }
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final permissionProvider = context.watch<PermissionProvider>();

    if (!permissionProvider.canGetByIdWorkshop()) {
      return MasterScreen(
        'Workshop Details',
        NoPermissionScreen(),
        currentScreen: "Workshops",
      );
    }

    return MasterScreen(
      "Workshop Details",
      currentScreen: "Workshops",
      SingleChildScrollView(
        padding: const EdgeInsets.all(64),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (!isLoading) Center(child: _buildForm()),
                      const SizedBox(height: 10),
                      if (permissionProvider.canPredictForNewWorkshop() &&
                          widget.workshop == null)
                        _buildInfoCard(),
                      if (_prediction != null) ...[
                        SizedBox(height: 20),
                        _buildPredictionCard(),
                      ],
                      const SizedBox(height: 40),
                      if ((permissionProvider.canEditWorkshop() &&
                              widget.workshop != null) ||
                          (permissionProvider.canInsertWorkshop() &&
                              widget.workshop == null) ||
                          (permissionProvider.canDeleteWorkshop() &&
                              widget.workshop != null))
                        _actionButtons(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      onBackPressed: () => workshopFormProvider.handleBackPressed(context),
    );
  }

  Widget _buildForm() {
    final workshopFormProvider = Provider.of<WorkshopFormProvider>(context);

    final permissionProvider = context.read<PermissionProvider>();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    List<String> allowedActions = [];

    _currentWorkshop != null
        ? allowedActions = workshopStatusFromString(_currentWorkshop!.status)
              .allowedActions
              .where((action) {
                switch (action) {
                  case "Publish":
                    return permissionProvider.canPublishWorkshop();
                  case "Cancel":
                    return permissionProvider.canCancelWorkshop();
                  case "Close":
                    return permissionProvider.canCloseWorkshop();
                  case "View Participants":
                    return permissionProvider.canViewParticipants();
                  default:
                    return false;
                }
              })
              .toList()
        : [];

    return FormBuilder(
      key: workshopFormProvider.formKey,
      autovalidateMode: AutovalidateMode.disabled,
      initialValue: _initialValue,
      onChanged: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (workshopFormProvider.isUpdate)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [buildSectionTitle("Workshop details", colorScheme)],
            ),
          if (!workshopFormProvider.isUpdate)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [buildSectionTitle("Add new workshop", colorScheme)],
            ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_currentWorkshop != null)
                      SizedBox(
                        width: 1000,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children:
                              // workshopStatusFromString(_currentWorkshop!.status)
                              //     .
                              allowedActions
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
                                              await Provider.of<
                                                    WorkshopProvider
                                                  >(context, listen: false)
                                                  .handleWorkshopAction(
                                                    _currentWorkshop!,
                                                    action,
                                                    context,
                                                  );

                                          if (result == true) {
                                            var updated =
                                                await Provider.of<
                                                      WorkshopProvider
                                                    >(context, listen: false)
                                                    .getById(
                                                      _currentWorkshop!
                                                          .workshopId,
                                                    );

                                            setState(() {
                                              _currentWorkshop = updated;
                                            });
                                          }
                                        },
                                        label: action,
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                    SizedBox(height: 10),
                    CustomTextField(
                      width: 1000,
                      name: 'name',
                      label: 'Workshop Name',
                      validator: (value) => workshopFormProvider
                          .validateServicWorkshopeName(value),
                      required: true,
                    ),
                    if (_currentWorkshop != null)
                      CustomTextField(
                        width: 1000,
                        name: 'status',
                        label: 'Workshop Status',
                        required: true,
                        enabled: false,
                      ),
                    CustomTextField(
                      width: 1000,
                      name: 'description',
                      label: 'Description',
                      maxLines: 5,
                      hintText: 'Write a short and clear description...',
                      validator: workshopFormProvider.validateDescription,
                      required: true,
                    ),
                    Row(
                      children: [
                        CustomDateField(
                          width: 1000,
                          name: 'date',
                          label: 'Date',
                          required: true,
                          timePicker: true,
                          validator: workshopFormProvider.validateDate,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        CustomTextField(
                          width: 1000,
                          name: 'price',
                          label: 'Price',
                          validator: workshopFormProvider.validatePrice,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        CustomTextField(
                          width: 1000,
                          name: 'maxParticipants',
                          label: 'Max Participants',
                          validator: workshopFormProvider.validatePrice,
                        ),
                      ],
                    ),
                    CustomDropdownField<String>(
                      width: 1000,
                      name: 'workshopType',
                      label: 'Workshop Type',
                      items: [
                        DropdownMenuItem(
                          value: "Parents",
                          child: Text('Parents'),
                        ),
                        DropdownMenuItem(
                          value: "Children",
                          child: Text('Children'),
                        ),
                      ],
                      validator: workshopFormProvider.validateNonEmpty,
                      required: true,
                    ),
                    CustomTextField(
                      width: 1000,
                      name: 'notes',
                      label: 'Notes',
                      maxLines: 3,
                      hintText: 'Write a short and clear description...',
                      validator: workshopFormProvider.validateNotes,
                    ),
                    if (workshopFormProvider.isUpdate)
                      CustomDateField(
                        width: 1000,
                        name: 'modifiedDate',
                        label: 'Last Edited',
                        enabled: false,
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 40, height: 60),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      color: AppColors.dustyRose,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: colorScheme.primary),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Get AI-powered predictions for workshop attendance based on historical data.',
                style: TextStyle(color: AppColors.darkBackground),
              ),
            ),
            SizedBox(width: 12),
            PrimaryButton(onPressed: _getPrediction, label: 'Get prediction'),
          ],
        ),
      ),
    );
  }

  Widget _buildPredictionCard() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final utilizationColor = _getPredictionColor(
      _prediction!.utilizationPercentage ?? 0,
    );

    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.insights, size: 32, color: colorScheme.primary),
                SizedBox(width: 12),
                Text(
                  'Prediction Results',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            Divider(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Predicted',
                  '${_prediction!.predictedParticipants.round()}',
                  Icons.people,
                  Colors.blue,
                ),
                _buildStatItem(
                  'Capacity',
                  '${_prediction!.maxParticipants ?? "Not set"}',
                  Icons.event_seat,
                  Colors.green,
                ),
                _buildStatItem(
                  'Utilization',
                  _prediction!.utilizationPercentage != null
                      ? "${_prediction!.utilizationPercentage!.toStringAsFixed(1)}%"
                      : "Cannot be calculated, add max paricipant",
                  Icons.percent,
                  utilizationColor,
                ),
              ],
            ),

            if (_prediction!.recommendation != null) ...[
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: utilizationColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: utilizationColor.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: utilizationColor),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _prediction!.recommendation!,
                        style: TextStyle(color: utilizationColor),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getPredictionColor(double utilization) {
    if (utilization >= 90) return Colors.red;
    if (utilization >= 70) return Colors.green;
    if (utilization >= 50) return Colors.orange;
    return Colors.red;
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, size: 32, color: color),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: TextStyle(color: Colors.grey.shade600)),
      ],
    );
  }

  Future<void> _getPrediction() async {
    final formState = workshopFormProvider.formKey.currentState;

    if (formState == null || !formState.saveAndValidate()) {
      debugPrint('Form is not valid or state is null');
      return;
    }
    setState(() {
      isLoadingPrediction = true;
      _errorMessage = null;
      _prediction = null;
    });

    try {
      final formData = workshopFormProvider.formKey.currentState?.value;

      if (formData == null) {
        return;
      }

      final prediction = await workshopProvider.predictForNewWorkshop(
        name: formData['name'],
        description: formData['description'],
        workshopType: formData['workshopType'],
        date: formData['date'],
        price: formData['price'] == null || formData['price'].toString().isEmpty
            ? null
            : double.tryParse(formData['price']),
        maxParticipants:
            formData['maxParticipants'] == null ||
                formData['maxParticipants'].toString().isEmpty
            ? null
            : int.tryParse(formData['maxParticipants']),
      );

      setState(() => _prediction = prediction);
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() => isLoadingPrediction = false);
    }
  }

  Widget _actionButtons() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final permissionProvider = context.read<PermissionProvider>();

    return SizedBox(
      width: 1000,
      child: Row(
        children: [
          if (_currentWorkshop != null &&
              permissionProvider.canDeleteWorkshop())
            PrimaryButton(
              onPressed: () async {
                delete();
              },
              label: 'Delete',
              backgroundColor: colorScheme.error,
            ),

          Spacer(),

          if ((_currentWorkshop == null ||
                  _currentWorkshop?.status == "Draft") &&
              ((permissionProvider.canEditWorkshop() &&
                      _currentWorkshop != null) ||
                  (permissionProvider.canInsertWorkshop() &&
                      _currentWorkshop == null)))
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
    final id = _currentWorkshop?.workshopId;

    final shouldProceed = await CustomConfirmDialog.show(
      context,
      icon: Icons.info,

      title: 'Delete Workshop',
      content: 'Are you sure you want to delete this service?',
      confirmText: 'Delete',
      cancelText: 'Cancel',
    );

    if (shouldProceed != true) return;

    final success = await workshopProvider.delete(id!);

    if (!mounted) return;

    CustomSnackbar.show(
      context,
      message: success
          ? 'Workshop successfully deleted.'
          : 'Something went wrong. Please try again.',
      type: success ? SnackbarType.success : SnackbarType.error,
    );

    if (success) {
      Navigator.of(context).pop();
    }
  }

  void save() async {
    final formState = workshopFormProvider.formKey.currentState;

    if (formState == null || !formState.saveAndValidate()) {
      debugPrint('Form is not valid or state is null');
      return;
    }

    final id = _currentWorkshop?.workshopId;
    final isInsert = _currentWorkshop == null;

    final shouldProceed = await CustomConfirmDialog.show(
      context,
      icon: Icons.info,
      iconBackgroundColor: AppColors.mauveGray,
      title: isInsert ? 'Add New Workshop' : 'Save Changes',
      content: isInsert
          ? 'Are you sure you want to add a new workshop?'
          : 'Are you sure you want to save the workshop?',
      confirmText: 'Continue',
      cancelText: 'Cancel',
    );

    if (shouldProceed != true) return;

    final success = await workshopFormProvider.saveOrUpdate(
      workshopFormProvider,
      workshopProvider,
      id,
    );

    if (!mounted) return;

    CustomSnackbar.show(
      context,
      message: success
          ? (workshopFormProvider.isUpdate
                ? 'Workshop updated.'
                : 'Workshop added.')
          : 'Something went wrong. Please try again.',
      type: success ? SnackbarType.success : SnackbarType.error,
    );

    if (success && !workshopFormProvider.isUpdate) {
      setState(() {});
      workshopFormProvider.resetForm();
    }

    if (success) {
      workshopFormProvider.saveInitialValue();
    }
    workshopFormProvider.success = success;
  }
}
