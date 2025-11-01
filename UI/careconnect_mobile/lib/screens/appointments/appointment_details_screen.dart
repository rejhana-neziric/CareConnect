import 'package:careconnect_mobile/core/theme/app_colors.dart';
import 'package:careconnect_mobile/models/enums/appointment_status.dart';
import 'package:careconnect_mobile/models/requests/appointment_reschedule_request.dart';
import 'package:careconnect_mobile/models/responses/appointment.dart';
import 'package:careconnect_mobile/providers/appointment_provider.dart';
import 'package:careconnect_mobile/providers/permission_provider.dart';
import 'package:careconnect_mobile/screens/appointments/scheduling_appointment/appointment_scheduling_screen.dart';
import 'package:careconnect_mobile/screens/no_permission_screen.dart';
import 'package:careconnect_mobile/widgets/confim_dialog.dart';
import 'package:careconnect_mobile/widgets/primary_button.dart';
import 'package:careconnect_mobile/widgets/snackbar.dart';
import 'package:flutter/material.dart';
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
  late AppointmentProvider appointmentProvider;
  late Appointment appointment;

  late AppointmentStatus status;

  late List<String> actions;

  @override
  void initState() {
    super.initState();

    appointmentProvider = context.read<AppointmentProvider>();
    appointment = widget.appointment;
    status = appointmentStatusFromString(widget.appointment.stateMachine!);
    actions = status.allowedActions;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final permissionProvider = context.read<PermissionProvider>();

    if (!permissionProvider.canGetByIdAppointment()) {
      return Scaffold(
        backgroundColor: colorScheme.surfaceContainerLow,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: colorScheme.surfaceContainerLow,
          foregroundColor: colorScheme.onSurface,
          title: Text(
            'Appointment Details',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        body: NoPermissionScreen(),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLow,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.surfaceContainerLow,
        foregroundColor: colorScheme.onSurface,
        title: Text(
          'Appointment Details',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: colorScheme.onSurface,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            _buildStatusCard(colorScheme),
            const SizedBox(height: 16),

            // Date & Time Card
            _buildDateTimeCard(colorScheme),
            const SizedBox(height: 16),

            // Emplyoee Info Card
            _buildEmployeeInfoCard(colorScheme),
            const SizedBox(height: 16),

            // Service Info Card
            _buildServiceInfoCard(colorScheme),
            const SizedBox(height: 40),

            // Action Buttons
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(ColorScheme colorScheme) {
    final status = widget.appointment.stateMachine ?? 'Unknown';

    final gradientColors = colorScheme.brightness == Brightness.light
        ? [
            colorScheme.primaryContainer,
            colorScheme.primary,
          ] // Light theme option
        : [colorScheme.surfaceContainerLowest, colorScheme.primary];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: appointmentStatusFromString(status).backgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              appointmentStatusFromString(
                widget.appointment.stateMachine!,
              ).label,
              style: TextStyle(
                color: appointmentStatusFromString(
                  widget.appointment.stateMachine!,
                ).textColor,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.appointment.appointmentType,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${widget.appointment.clientsChild?.child.firstName} ${widget.appointment.clientsChild?.child.lastName}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceInfoCard(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow(
            FontAwesomeIcons.handHoldingHeart,
            'Service Name and Type',
            widget.appointment.employeeAvailability?.service?.name ??
                'Unavailable',
            widget
                    .appointment
                    .employeeAvailability
                    ?.service
                    ?.serviceType
                    ?.name ??
                'Unavailable',
            colorScheme,
          ),
          const Divider(height: 24),
          _buildInfoRow(
            FontAwesomeIcons.dollarSign,
            'Price',
            widget.appointment.employeeAvailability?.service?.price
                    .toString() ??
                'Not specified',
            null,
            colorScheme,
          ),
          const Divider(height: 24),
          _buildInfoRow(
            Icons.info,
            'Service Description',
            widget.appointment.employeeAvailability?.service?.description ??
                'Not specified',
            null,
            colorScheme,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final permissionProvider = context.read<PermissionProvider>();

    if (actions.isEmpty) return SizedBox.shrink();

    return Column(
      children: [
        Row(
          children: actions.map((action) {
            Color? backgroundColor;
            VoidCallback onPressed;

            switch (action) {
              case 'Cancel':
                if (!permissionProvider.canCancelAppointment()) {
                  return const SizedBox.shrink();
                }
                backgroundColor = Colors.red;
                onPressed = () => _cancelAppointment(widget.appointment);
                break;
              case 'Choose new time':
                if (!permissionProvider.canRescheduleAppointment()) {
                  return const SizedBox.shrink();
                }
                backgroundColor = AppColors.accentDeepMauve;
                onPressed = () => _requestNewAppointmentTime(
                  // appointmentId: widget.appointment.appointmentId,
                  // request: new AppointmentRescheduleRequest(),
                );
                break;

              default:
                backgroundColor = null;
                onPressed = () {};
            }

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: PrimaryButton(
                  label: action,
                  onPressed: onPressed,
                  backgroundColor: backgroundColor,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String title,
    String value,
    String? subtitle,
    ColorScheme colorScheme,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: colorScheme.primary, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimeCard(ColorScheme colorScheme) {
    final date = widget.appointment.date;
    final startTime =
        widget.appointment.employeeAvailability?.startTime ??
        DateFormat('HH:mm').format(date);
    final endTime = widget.appointment.employeeAvailability?.endTime ?? 'TBD';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 25),
                decoration: BoxDecoration(
                  //color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.calendar_month,
                  color: colorScheme.primary,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Appointment Date',
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('EEEE, d. MM. yyyy.').format(date),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 32),
          Row(
            children: [
              Expanded(
                child: _buildTimeInfo(
                  Icons.access_time,
                  'Start Time',
                  _formatTime(startTime),
                  colorScheme.secondary,
                  colorScheme,
                ),
              ),
              Container(width: 1, height: 40, color: Colors.grey[200]),
              Expanded(
                child: _buildTimeInfo(
                  Icons.schedule,
                  'End Time',
                  _formatTime(endTime),
                  colorScheme.secondary,
                  colorScheme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeInfo(
    IconData icon,
    String label,
    String time,
    Color color,
    ColorScheme colorScheme,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              time,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmployeeInfoCard(ColorScheme colorScheme) {
    final employee = widget.appointment.employeeAvailability?.employee;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Employee Information',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${employee?.user?.firstName ?? ''} ${employee?.user?.lastName ?? ''}'
                              .trim()
                              .isNotEmpty
                          ? '${employee?.user?.firstName ?? ''} ${employee?.user?.lastName ?? ''}'
                                .trim()
                          : 'Service Provider',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (employee?.jobTitle != null) ...[
                      Text(
                        employee!.jobTitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    if (employee?.user?.phoneNumber != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            employee!.user!.phoneNumber!,
                            style: TextStyle(
                              fontSize: 14,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ],

                    if (employee?.user?.email != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.email, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            employee!.user!.email!,
                            style: TextStyle(
                              fontSize: 14,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(String timeString) {
    try {
      final timeParts = timeString.split(':');
      if (timeParts.length >= 2) {
        final hour = int.parse(timeParts[0]);
        final minute = int.parse(timeParts[1]);
        final time = TimeOfDay(hour: hour, minute: minute);
        final now = DateTime.now();
        final dateTime = DateTime(
          now.year,
          now.month,
          now.day,
          time.hour,
          time.minute,
        );
        return DateFormat('h:mm a').format(dateTime);
      }
      return timeString;
    } catch (e) {
      return timeString;
    }
  }

  Future<void> _handleAppointmentAction({
    required Appointment appointment,
    required String title,
    required String content,
    required String confirmText,
    required Future<bool> Function({required int appointmentId}) action,
    required String successMessage,
    Future<void> Function()? onSuccess,
  }) async {
    final shouldProceed = await CustomConfirmDialog.show(
      context,
      icon: Icons.info,
      iconBackgroundColor: AppColors.mauveGray,
      title: title,
      content: content,
      confirmText: confirmText,
      cancelText: 'Cancel',
    );

    if (shouldProceed != true) return;

    final success = await action(appointmentId: appointment.appointmentId);

    if (!mounted) return;

    CustomSnackbar.show(
      context,
      message: success
          ? successMessage
          : 'Something went wrong. Please try again.',
      type: success ? SnackbarType.success : SnackbarType.error,
    );

    if (success && onSuccess != null) {
      await onSuccess();
    }
  }

  void _cancelAppointment(Appointment appointment) => _handleAppointmentAction(
    appointment: appointment,
    title: 'Cancel Appointment',
    content: 'Are you sure you want to cancel appointment?',
    confirmText: 'Cancel',
    action: appointmentProvider.cancelAppointment,
    successMessage: 'You have successfully canceled the appointment.',
    onSuccess: () async {
      setState(() {
        appointment.stateMachine = "Canceled";
        actions = [];
      });
    },
  );

  Future<void> _requestNewAppointmentTime(
    //   {
    //   required int appointmentId,
    //   required AppointmentRescheduleRequest request,
    // }
  ) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppointmentSchedulingScreen(
          clientId: appointment.clientId,
          childId: appointment.childId,
          employee: appointment.employeeAvailability!.employee,
          service: appointment.employeeAvailability!.service!,
          isRescheduling: true,
          appointmentId: appointment.appointmentId,
        ),
      ),
    );

    // final shouldProceed = await CustomConfirmDialog.show(
    //   context,
    //   icon: Icons.info,
    //   iconBackgroundColor: AppColors.mauveGray,
    //   title: '',
    //   content: '',
    //   confirmText: 'Confirm new time',
    //   cancelText: 'Cancel',
    // );

    // if (shouldProceed != true) return;

    // final success = await appointmentProvider.requestNewAppointmentTime(
    //   appointmentId: appointmentId,
    //   request: request,
    // );

    // if (!mounted) return;

    // CustomSnackbar.show(
    //   context,
    //   message: success
    //       ? 'You have successfully chose new appointment time. You will be notified when employee reviews request.'
    //       : 'Something went wrong. Please try again.',
    //   type: success ? SnackbarType.success : SnackbarType.error,
    // );
  }
}
