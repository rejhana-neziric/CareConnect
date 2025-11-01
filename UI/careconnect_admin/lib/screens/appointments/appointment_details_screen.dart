import 'package:careconnect_admin/core/layouts/master_screen.dart';
import 'package:careconnect_admin/core/theme/app_colors.dart';
import 'package:careconnect_admin/models/enums/appointment_status.dart';
import 'package:careconnect_admin/models/requests/appointment_update_request.dart';
import 'package:careconnect_admin/models/responses/appointment.dart';
import 'package:careconnect_admin/models/responses/attendance_status.dart';
import 'package:careconnect_admin/providers/appointment_provider.dart';
import 'package:careconnect_admin/providers/attendance_status_provider.dart';
import 'package:careconnect_admin/providers/permission_provider.dart';
import 'package:careconnect_admin/screens/no_permission_screen.dart';
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

class AppointmentDetailsScreen extends StatefulWidget {
  final Appointment appointment;

  const AppointmentDetailsScreen({super.key, required this.appointment});

  @override
  State<AppointmentDetailsScreen> createState() =>
      _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  bool isLoading = false;

  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};

  List<String> appointmentTypes = [];
  List<AttendanceStatus> attendanceStatuses = [];

  late AppointmentProvider appointmentProvider;
  late AttendanceStatusProvider attendanceStatusProvider;

  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();

    appointmentProvider = context.read<AppointmentProvider>();
    attendanceStatusProvider = context.read<AttendanceStatusProvider>();

    initForm();
  }

  Future<void> initForm() async {
    setState(() {
      isLoading = true;
    });

    _initialValue = {
      "date": widget.appointment.date,
      "time":
          '${widget.appointment.employeeAvailability?.startTime} - ${widget.appointment.employeeAvailability?.endTime}',
      "appointmentType": widget.appointment.appointmentType,
      "employeeName":
          '${widget.appointment.employeeAvailability?.employee.user?.firstName} ${widget.appointment.employeeAvailability?.employee.user?.lastName}',
      "childName":
          '${widget.appointment.clientsChild.child.firstName} ${widget.appointment.clientsChild.child.lastName}',
      "childBirthDate": widget.appointment.clientsChild.child.birthDate,
      "clientName":
          '${widget.appointment.clientsChild.client.user?.firstName} ${widget.appointment.clientsChild.client.user?.lastName}',
      "clientPhoneNumber":
          widget.appointment.clientsChild.client.user?.phoneNumber,
      "description": widget.appointment.description,
      "notes": widget.appointment.note,
      "attendanceStatusId": widget.appointment.attendanceStatusId,
    };

    setState(() {
      isLoading = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_formKey.currentState != null) {
        _formKey.currentState!.patchValue(_initialValue);
      }
    });

    loadAppointmentTypes();
    loadAttendanceStatus();

    setState(() {});
  }

  Future<void> loadAppointmentTypes() async {
    final result = await appointmentProvider.getAppoinmentTypes();

    setState(() {
      appointmentTypes = result.toSet().toList()..sort();
    });
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

    if (!permissionProvider.canGetByIdAppointment()) {
      return MasterScreen(
        'Appointment Details',
        NoPermissionScreen(),
        currentScreen: "Appointments",
      );
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _hasChanges);
        return false;
      },
      child: MasterScreen(
        'Appointment Details',
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
                          // Main Info Card
                          _buildMainInfoCard(permissionProvider),
                          const SizedBox(height: 24),

                          // Patient & Child Info
                          _buildPatientInfoCard(),
                          const SizedBox(height: 24),

                          // Description & Notes
                          _buildDescriptionCard(permissionProvider),
                          const SizedBox(height: 24),

                          if (permissionProvider.canEditAppointment())
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
        currentScreen: "Appointments",
      ),
    );
  }

  Widget _buildMainInfoCard(PermissionProvider permissionProvider) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appointment Information',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: CustomDateField(
                    width: 400,
                    name: 'date',
                    label: 'Date',
                    enabled: false,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomTextField(
                    width: double.infinity,
                    name: 'time',
                    label: 'Time',
                    enabled: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomDropdownField<String>(
                    width: 600,
                    name: 'appointmentType',
                    label: 'Appointment Type',
                    items: appointmentTypes
                        .map(
                          (type) => DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          ),
                        )
                        .toList(),
                    required: true,
                    validator: (value) {
                      if (value == null) return 'Appointment type is required';
                      return null;
                    },
                    enabled: permissionProvider.canEditAppointment(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomTextField(
                    width: double.infinity,
                    name: 'employeeName',
                    label: 'Employee',
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

  Widget _buildPatientInfoCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Patient Information',
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
                    name: 'childName',
                    label: 'Child Name',
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
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    width: double.infinity,
                    name: 'clientName',
                    label: 'Parent Name',
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

  Widget _buildDescriptionCard(PermissionProvider permissionProvider) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description & Notes',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            CustomTextField(
              width: double.infinity,
              name: 'description',
              label: 'Description',
              maxLines: 3,
              enabled: permissionProvider.canEditAppointment(),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              width: double.infinity,
              name: 'note',
              label: 'Notes',
              maxLines: 3,
              enabled: permissionProvider.canEditAppointment(),
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
            if (widget.appointment.employeeAvailability?.service?.price != null)
              _buildSidebarItem(
                icon: Icons.payment_outlined,
                label: 'Payment Status',
                value: widget.appointment.paid == true ? 'Paid' : 'Not paid',
                valueColor: widget.appointment.paid == true
                    ? Colors.green
                    : Colors.orange,
              ),
            const Divider(height: 32),
            _buildSidebarItem(
              icon: FontAwesomeIcons.handHoldingHeart,
              label: 'Service',
              value:
                  widget.appointment.employeeAvailability?.service?.name ??
                  'General',
            ),
            const Divider(height: 32),
            _buildSidebarItem(
              icon: Icons.update,
              label: 'Last Modified',
              value: DateFormat(
                'dd. MM. yyyy',
              ).format(widget.appointment.modifiedDate),
            ),
            const SizedBox(height: 32),
            if (widget.appointment.stateMachine != null) ...[
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
                  color: appointmentStatusFromString(
                    widget.appointment.stateMachine ?? '',
                  ).backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  appointmentStatusFromString(
                    widget.appointment.stateMachine ?? '',
                  ).label,
                  style: TextStyle(
                    fontSize: 12,
                    color: appointmentStatusFromString(
                      widget.appointment.stateMachine ?? '',
                    ).textColor,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(PermissionProvider permissionProvider) {
    return CustomDropdownField<int>(
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
    );
  }

  List<DropdownMenuItem<int>> buildAttendanceStatusItems(
    List<AttendanceStatus> attendanceStatuses,
  ) {
    return attendanceStatuses.map((attendanceStatus) {
      return DropdownMenuItem<int>(
        value: attendanceStatus.attendanceStatusId,
        child: Text(attendanceStatus.name ?? 'Not provided'),
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
      content: 'Are you sure you want to save changes?',
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

      final updateAppointment = AppointmentUpdateRequest(
        appointmentType: formData['appointmentType'],
        attendanceStatusId: formData['attendanceStatusId'],
        description: formData['description']?.isEmpty == true
            ? null
            : formData['description'],
        note: formData['note']?.isEmpty == true ? null : formData['note'],
      );

      await appointmentProvider.update(
        widget.appointment.appointmentId,
        updateAppointment,
      );

      CustomSnackbar.show(
        context,
        message: 'Successfully updated appointment.',
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
