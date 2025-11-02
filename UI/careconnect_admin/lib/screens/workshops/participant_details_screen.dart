import 'package:careconnect_admin/core/layouts/master_screen.dart';
import 'package:careconnect_admin/core/theme/app_colors.dart';
import 'package:careconnect_admin/models/enums/workshop_status.dart';
import 'package:careconnect_admin/models/requests/attendance_status_insert_request.dart';
import 'package:careconnect_admin/models/requests/participant_update_request.dart';
import 'package:careconnect_admin/models/responses/attendance_status.dart';
import 'package:careconnect_admin/models/responses/participant.dart';
import 'package:careconnect_admin/models/responses/workshop.dart';
import 'package:careconnect_admin/providers/attendance_status_provider.dart';
import 'package:careconnect_admin/providers/participant_provider.dart';
import 'package:careconnect_admin/providers/permission_provider.dart';
import 'package:careconnect_admin/widgets/confirm_dialog.dart';
import 'package:careconnect_admin/widgets/custom_date_field.dart';
import 'package:careconnect_admin/widgets/custom_dropdown_field.dart';
import 'package:careconnect_admin/widgets/custom_text_field.dart';
import 'package:careconnect_admin/widgets/primary_button.dart';
import 'package:careconnect_admin/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ParticipantDetailsScreen extends StatefulWidget {
  final Participant participant;
  final Workshop workshop;

  const ParticipantDetailsScreen({
    super.key,
    required this.participant,
    required this.workshop,
  });

  @override
  State<ParticipantDetailsScreen> createState() =>
      _ParticipantDetailsScreenState();
}

class _ParticipantDetailsScreenState extends State<ParticipantDetailsScreen> {
  bool isLoading = false;

  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};

  late AttendanceStatusProvider attendanceStatusProvider;
  late ParticipantProvider participantProvider;

  List<AttendanceStatus> attendanceStatuses = [];

  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();

    attendanceStatusProvider = context.read<AttendanceStatusProvider>();
    participantProvider = context.read<ParticipantProvider>();

    initForm();
  }

  Future<void> initForm() async {
    setState(() {
      isLoading = true;
    });

    _initialValue = {
      "childName":
          '${widget.participant.child?.firstName} ${widget.participant.child?.lastName}',
      "childFirstName": widget.participant.child?.firstName,
      "childLastName": widget.participant.child?.lastName,
      "childBirthDate": widget.participant.child?.birthDate,
      "childGender": widget.participant.child?.gender == 'M'
          ? 'Male'
          : 'Female',
      "clientName":
          '${widget.participant.user?.firstName} ${widget.participant.user?.lastName}',
      "clientBirthDate": widget.participant.user?.birthDate ?? 'Not provided',
      "clientPhoneNumber":
          widget.participant.user?.phoneNumber ?? 'Not provided',
      "clientEmail": widget.participant.user?.email ?? 'Not provided',
      "attendanceStatusId": widget.participant.attendanceStatusId,
    };

    setState(() {
      isLoading = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_formKey.currentState != null) {
        _formKey.currentState!.patchValue(_initialValue);
      }
    });

    loadAttendanceStatus();

    setState(() {});
  }

  Future<void> loadAttendanceStatus() async {
    final result = await attendanceStatusProvider.get();

    setState(() {
      attendanceStatuses = result.result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final permissionProvider = context.watch<PermissionProvider>();

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _hasChanges);
        return false;
      },
      child: MasterScreen(
        'Participant Details',
        Scaffold(
          backgroundColor: colorScheme.surfaceContainerLow,
          body: SafeArea(
            child: FormBuilder(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
              initialValue: _initialValue,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildClientInfoCard(),
                          const SizedBox(height: 24),

                          if (widget.workshop.workshopType == 'Children') ...[
                            _buildChildInfoCard(),
                            const SizedBox(height: 24),
                          ],

                          if (permissionProvider.canEditParticipant())
                            _buildActionButtons(),
                        ],
                      ),
                    ),
                  ),

                  // Sidebar
                  Container(
                    width: 320,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLowest,
                      border: Border(
                        left: BorderSide(color: Colors.grey[200]!),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: _buildSidebar(permissionProvider),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        currentScreen: "Workshops",
      ),
    );
  }

  Widget _buildClientInfoCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.workshop.workshopType == 'Children'
                  ? 'Parent Information'
                  : 'Client Information',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    width: double.infinity,
                    name: 'clientName',
                    label: widget.workshop.workshopType == 'Children'
                        ? 'Parent Name'
                        : 'Client Name',
                    enabled: false,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomDateField(
                    width: 400,
                    name: 'clientBirthDate',
                    label: 'Birth Date',
                    enabled: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    width: double.infinity,
                    name: 'clientEmail',
                    label: 'Email',
                    enabled: false,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomTextField(
                    width: double.infinity,
                    name: 'clientPhoneNumber',
                    label: 'Phone Number',
                    prefixText: '+387 ',
                    enabled: false,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChildInfoCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Child Information',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    width: double.infinity,
                    name: 'childFirstName',
                    label: 'First Name',
                    enabled: false,
                  ),
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: CustomTextField(
                    width: double.infinity,
                    name: 'childLastName',
                    label: 'Last Name',
                    enabled: false,
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    width: double.infinity,
                    name: 'childGender',
                    label: 'Gender',
                    enabled: false,
                  ),
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: CustomDateField(
                    width: 400,
                    name: 'childBirthDate',
                    label: 'Birth Date',
                    enabled: false,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebar(PermissionProvider permissionProvider) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      child: Container(
        color: colorScheme.surfaceContainerLowest,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Info',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 24),
            _buildStatusChip(permissionProvider),
            const SizedBox(height: 24),
            if (widget.workshop.price != null)
              _buildSidebarItem(
                icon: Icons.payment_outlined,
                label: 'Payment Status',
                value: widget.workshop.paid == true ? 'Paid' : 'Not paid',
                valueColor: widget.workshop.paid == true
                    ? Colors.green
                    : Colors.orange,
              ),
            const Divider(height: 32),
            _buildSidebarItem(
              icon: FontAwesomeIcons.handHoldingHeart,
              label: 'Workshop',
              value: widget.workshop.name,
            ),
            const Divider(height: 32),
            _buildSidebarItem(
              icon: Icons.update,
              label: 'Registation Date',
              value: DateFormat(
                'dd. MM. yyyy',
              ).format(widget.participant.registrationDate),
            ),
            const SizedBox(height: 32),
            // if (widget.workshop.status) ...[
            Text(
              'Workflow',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: workshopStatusFromString(
                  widget.workshop.status,
                ).backgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                workshopStatusFromString(widget.workshop.status).label,
                style: TextStyle(
                  fontSize: 12,
                  color: workshopStatusFromString(
                    widget.workshop.status,
                  ).textColor,
                ),
              ),
            ),
            // ],
          ],
        ),
      ),
    );
  }

  // Widget _buildStatusChip(PermissionProvider permissionProvider) {
  //   return CustomDropdownField<int>(
  //     width: 600,
  //     name: 'attendanceStatusId',
  //     label: 'Attendance Status',
  //     items: buildAttendanceStatusItems(attendanceStatuses),
  //     required: true,
  //     validator: (value) {
  //       if (value == null) return 'Attendance status is required';
  //       return null;
  //     },
  //     enabled: permissionProvider.canEditAppointment(),
  //   );
  // }

  Widget _buildStatusChip(PermissionProvider permissionProvider) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: CustomDropdownField<int>(
            width: 600,
            name: 'attendanceStatusId',
            label: 'Attendance Status',
            items: buildAttendanceStatusItems(attendanceStatuses),
            required: true,
            validator: (value) {
              if (value == null) return 'Attendance status is required';
              return null;
            },
            enabled: permissionProvider.canEditAppointment(),
          ),
        ),
        const SizedBox(width: 8),
        // if (canManageStatuses)
        IconButton(
          tooltip: 'Manage Attendance Statuses',
          icon: const Icon(Icons.settings_outlined),
          color: Colors.grey[700],
          onPressed: () => _openManageStatusesDialog(context),
        ),
      ],
    );
  }

  void _openManageStatusesDialog(BuildContext context) async {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) {
        TextEditingController nameController = TextEditingController();
        AttendanceStatus? editingStatus;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'Manage Attendance Statuses',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SizedBox(
                width: 500,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Existing statuses list
                    if (attendanceStatuses.isEmpty)
                      const Text('No statuses found.'),
                    if (attendanceStatuses.isNotEmpty)
                      ...attendanceStatuses.map((status) {
                        return ListTile(
                          title: Text(status.name),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  nameController.text = status.name;
                                  editingStatus = status;
                                  setState(() {});
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  final result = await _deleteStatus(
                                    status.attendanceStatusId,
                                  );
                                  setState(() {
                                    if (result == true) {
                                      attendanceStatuses.remove(status);
                                      loadAttendanceStatus();
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      }),
                    const Divider(),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: editingStatus == null
                            ? 'Add new status'
                            : 'Edit status',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.pop(context),
                ),

                PrimaryButton(
                  onPressed: () async {
                    final name = nameController.text.trim();
                    if (name.isEmpty) return;

                    if (editingStatus == null) {
                      await _addStatus(name);
                      setState(() {
                        loadAttendanceStatus();
                        // attendanceStatuses.add(newStatus);
                      });
                    } else {
                      final updatedStatus = await _updateStatus(
                        editingStatus!.attendanceStatusId, // fix
                        name,
                      );
                      setState(() {
                        final index = attendanceStatuses.indexWhere(
                          (status) =>
                              status.attendanceStatusId ==
                              updatedStatus.attendanceStatusId,
                        );

                        if (index != -1) {
                          attendanceStatuses[index] = updatedStatus;
                        }

                        editingStatus = null;
                      });
                    }

                    nameController.clear();
                  },
                  label: editingStatus == null ? 'Add' : 'Update',
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<AttendanceStatus> _addStatus(String name) async {
    final newStatus = AttendanceStatusInsertRequest(name: name);
    return await attendanceStatusProvider.insert(newStatus);
  }

  Future<AttendanceStatus> _updateStatus(int id, String name) async {
    final updated = AttendanceStatus(attendanceStatusId: id, name: name);
    return await attendanceStatusProvider.update(id, updated);
  }

  Future<bool> _deleteStatus(int id) async {
    final result = await attendanceStatusProvider.delete(id);

    if (result == false) {
      Navigator.pop(context);

      CustomSnackbar.show(
        context,
        message:
            'Sorry, you cannot delete attendance status that was used in appointment or workshop.',
        type: SnackbarType.error,
      );

      return false;
    }

    return true;
  }

  List<DropdownMenuItem<int>> buildAttendanceStatusItems(
    List<AttendanceStatus> attendanceStatuses,
  ) {
    return attendanceStatuses.map((attendanceStatus) {
      return DropdownMenuItem<int>(
        value: attendanceStatus.attendanceStatusId,
        child: Text(attendanceStatus.name),
      );
    }).toList();
  }

  Widget _buildSidebarItem({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: colorScheme.onSurface),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: valueColor ?? colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [PrimaryButton(onPressed: _save, label: 'Save changes')],
    );
  }

  void _save() async {
    final formState = _formKey.currentState;

    if (formState == null || !formState.saveAndValidate()) {
      debugPrint('Form is not valid or state is null');
      return;
    }

    final shouldProceed = await CustomConfirmDialog.show(
      context,
      icon: Icons.info,
      iconBackgroundColor: AppColors.mauveGray,
      title: 'Save Changes',
      content: 'Are you sure you want to save new attendance status?',
      confirmText: 'Save',
      cancelText: 'Cancel',
    );

    if (shouldProceed != true) return;

    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      final formData = _formKey.currentState?.value;

      if (formData == null) {
        return;
      }

      final updateStatus = ParticipantUpdateRequest(
        attendanceStatusId: formData['attendanceStatusId'],
      );

      await participantProvider.update(
        widget.participant.participantId,
        updateStatus.toJson(),
      );

      CustomSnackbar.show(
        context,
        message: 'Successfully updated attendance status.',
        type: SnackbarType.success,
      );

      setState(() => _hasChanges = true);
      Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        CustomSnackbar.show(
          context,
          message: 'Something went wrong. Please try again.',
          type: SnackbarType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
