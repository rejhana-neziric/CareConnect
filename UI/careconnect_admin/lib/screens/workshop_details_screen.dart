import 'package:careconnect_admin/layouts/master_screen.dart';
import 'package:careconnect_admin/models/enums/workshop_status.dart';
import 'package:careconnect_admin/models/responses/search_result.dart';
import 'package:careconnect_admin/models/responses/workshop.dart';
import 'package:careconnect_admin/providers/workshop_form_provider.dart';
import 'package:careconnect_admin/providers/workshop_provider.dart';
import 'package:careconnect_admin/theme/app_colors.dart';
import 'package:careconnect_admin/utils.dart';
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
  Workshop? workshop;

  WorkshopDetailsScreen({super.key, this.workshop});

  @override
  State<WorkshopDetailsScreen> createState() => _WorkshopDetailsScreenState();
}

class _WorkshopDetailsScreenState extends State<WorkshopDetailsScreen> {
  Map<String, dynamic> _initialValue = {};
  SearchResult<Workshop>? result;
  late WorkshopProvider workshopProvider;
  late WorkshopFormProvider workshopFormProvider;
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    workshopProvider = context.read<WorkshopProvider>();
    workshopFormProvider = context.read<WorkshopFormProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initForm();
    });
  }

  Future<void> initForm() async {
    if (widget.workshop == null) {
      workshopFormProvider.setForInsert();
    } else {
      workshopFormProvider.setForUpdate({
        "name": widget.workshop?.name,
        "status": widget.workshop?.status,
        "description": widget.workshop?.description,
        "workshopType": widget.workshop?.workshopType,
        "startDate": widget.workshop?.startDate,
        "endDate": widget.workshop?.endDate,
        "price": widget.workshop?.price == null
            ? ""
            : widget.workshop?.price.toString(),
        "memberPrice": widget.workshop?.memberPrice == null
            ? ""
            : widget.workshop?.memberPrice.toString(),
        "maxParticipants": widget.workshop?.maxParticipants == null
            ? ""
            : widget.workshop?.maxParticipants.toString(),
        "participants": widget.workshop?.participants == null
            ? ""
            : widget.workshop?.participants.toString(),
        "modifiedDate": widget.workshop?.modifiedDate,
        "notes": widget.workshop?.notes ?? "No notes",
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
    return MasterScreen(
      "Workshop Details",
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
      onBackPressed: () => workshopFormProvider.handleBackPressed(context),
    );
  }

  Widget _buildForm() {
    final workshopFormProvider = Provider.of<WorkshopFormProvider>(context);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
                    if (widget.workshop != null)
                      SizedBox(
                        width: 600,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children:
                              workshopStatusFromString(widget.workshop!.status)
                                  .allowedActions
                                  .map(
                                    (action) => Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: PrimaryButton(
                                        onPressed: () async {
                                          if (action != "View participants") {
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
                                                    widget.workshop!,
                                                    action,
                                                    context,
                                                  );

                                          if (result == true) {
                                            var updated =
                                                await Provider.of<
                                                      WorkshopProvider
                                                    >(context, listen: false)
                                                    .getById(
                                                      widget
                                                          .workshop!
                                                          .workshopId,
                                                    );

                                            setState(() {
                                              widget.workshop = updated;
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
                      width: 600,
                      name: 'name',
                      label: 'Workshop Name',
                      validator: (value) => workshopFormProvider
                          .validateServicWorkshopeName(value),
                      required: true,
                    ),
                    if (widget.workshop != null)
                      CustomTextField(
                        width: 600,
                        name: 'status',
                        label: 'Workshop Status',
                        required: true,
                        enabled: false,
                      ),
                    CustomTextField(
                      width: 600,
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
                          width: 290,
                          name: 'startDate',
                          label: 'Start Date',
                          required: true,
                        ),
                        SizedBox(width: 20),
                        CustomDateField(
                          width: 290,
                          name: 'endDate',
                          label: 'End Date',
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        CustomTextField(
                          width: 290,
                          name: 'price',
                          label: 'Price',
                          validator: workshopFormProvider.validatePrice,
                        ),
                        SizedBox(width: 20),
                        CustomTextField(
                          width: 290,
                          name: 'memberPrice',
                          label: 'Member Price',
                          validator: workshopFormProvider.validatePrice,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        CustomTextField(
                          width: 290,
                          name: 'maxParticipants',
                          label: 'Max Participants',
                          validator: workshopFormProvider.validatePrice,
                        ),
                        SizedBox(width: 20),
                        CustomTextField(
                          width: 290,
                          name: 'participants',
                          label: 'Participants',
                          validator: workshopFormProvider.validatePrice,
                        ),
                      ],
                    ),
                    CustomDropdownField<String>(
                      width: 600,
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
                      width: 600,
                      name: 'notes',
                      label: 'Notes',
                      maxLines: 3,
                      hintText: 'Write a short and clear description...',
                      validator: workshopFormProvider.validateDescription,
                    ),
                    if (workshopFormProvider.isUpdate)
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
          const SizedBox(width: 40, height: 60),
        ],
      ),
    );
  }

  Widget _actionButtons() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: 600,
      child: Row(
        children: [
          if (widget.workshop != null)
            PrimaryButton(
              onPressed: () async {
                delete();
              },
              label: 'Delete',
              backgroundColor: colorScheme.error,
            ),

          Spacer(),

          if (widget.workshop == null || widget.workshop?.status == "Draft")
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
    final id = widget.workshop?.workshopId;

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

    final id = widget.workshop?.workshopId;
    final isInsert = widget.workshop == null;

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
