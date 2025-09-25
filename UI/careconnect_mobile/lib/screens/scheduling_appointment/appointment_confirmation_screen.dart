import 'package:careconnect_mobile/core/theme/app_colors.dart';
import 'package:careconnect_mobile/models/requests/appointment_insert_request.dart';
import 'package:careconnect_mobile/models/responses/child.dart';
import 'package:careconnect_mobile/models/responses/employee.dart';
import 'package:careconnect_mobile/models/responses/employee_availability.dart';
import 'package:careconnect_mobile/models/time_slot.dart';
import 'package:careconnect_mobile/providers/appointment_provider.dart';
import 'package:careconnect_mobile/providers/clients_child_provider.dart';
import 'package:careconnect_mobile/screens/scheduling_appointment/appointment_success_screen.dart';
import 'package:careconnect_mobile/widgets/confim_dialog.dart';
import 'package:careconnect_mobile/widgets/primary_button.dart';
import 'package:careconnect_mobile/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AppointmentConfirmationScreen extends StatefulWidget {
  final DateTime selectedDate;
  final TimeSlot selectedTime;
  final Employee selectedEmployee;
  final EmployeeAvailability availability;
  final int clientId;
  final int childId;

  const AppointmentConfirmationScreen({
    super.key,
    required this.selectedDate,
    required this.selectedTime,
    required this.selectedEmployee,
    required this.availability,
    required this.clientId,
    required this.childId,
  });

  @override
  State<AppointmentConfirmationScreen> createState() =>
      _AppointmentConfirmationScreenState();
}

class _AppointmentConfirmationScreenState
    extends State<AppointmentConfirmationScreen> {
  String? selectedAppointmentType;
  List<String> appointmentTypes = [];

  bool _isSubmitting = false;

  List<Child> children = [];

  int? selectedChildId;

  late AppointmentProvider appointmentProvider;
  late ClientsChildProvider clientsChildProvider;

  @override
  void initState() {
    super.initState();

    appointmentProvider = context.read<AppointmentProvider>();
    clientsChildProvider = context.read<ClientsChildProvider>();

    loadAppoinmentTypes();
    loadChildren();
  }

  void loadAppoinmentTypes() async {
    final result = await appointmentProvider.getAppoinmentTypes();

    setState(() {
      appointmentTypes = result;
      selectedAppointmentType = appointmentTypes.first;
    });
  }

  void loadChildren() async {
    final result = await clientsChildProvider.getChildren(widget.clientId);

    setState(() {
      children = result;
      selectedChildId = children.first.childId;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLow,
      appBar: AppBar(
        title: Text(
          'Confirm Appointment',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        backgroundColor: colorScheme.surfaceContainerLow,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Appointment Summary Card
                  _buildAppointmentSummaryCard(colorScheme),

                  SizedBox(height: 20),

                  //Appointment Type
                  Text(
                    'Appointment Type',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 12),

                  _buildAppointmentType(colorScheme),

                  SizedBox(height: 20),

                  if (children.length > 1) ...[
                    //Select Child
                    Text(
                      'Select Child',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 12),

                    _buildSelectChild(colorScheme),

                    SizedBox(height: 20),
                  ],

                  SizedBox(height: 24),

                  _buildReminder(colorScheme),

                  SizedBox(height: 24),
                ],
              ),
            ),
          ),

          _buildActionButtons(colorScheme),
        ],
      ),
    );
  }

  Widget _buildAppointmentSummaryCard(ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.check_circle,
                  color: Color(0xFF4CAF50),
                  size: 18,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Appointment Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Please review your appointment details',
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24),

          // Date
          _buildInfoRow(
            Icons.calendar_today,
            'Date',
            DateFormat('EEEE, d MMMM, y').format(widget.selectedDate),
            colorScheme,
          ),
          SizedBox(height: 16),

          // Time
          _buildInfoRow(
            Icons.access_time,
            'Time',
            widget.selectedTime.displayTime,
            colorScheme,
          ),
          SizedBox(height: 16),

          // Employee
          _buildInfoRow(
            Icons.person,
            'Employee',
            '${widget.selectedEmployee.user?.firstName} ${widget.selectedEmployee.user?.lastName}',
            colorScheme,
          ),
          SizedBox(height: 16),

          // Service
          _buildInfoRow(
            Icons.medical_services,
            'Service',
            widget.availability.service?.name ?? 'Service',
            colorScheme,
          ),
          SizedBox(height: 16),

          // Service Type
          _buildInfoRow(
            Icons.medical_services,
            'Service Type',
            widget.availability.service?.serviceType?.name ?? 'Service Type',
            colorScheme,
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value,
    ColorScheme colorScheme,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: colorScheme.primary, size: 18),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppointmentType(ColorScheme colorScheme) {
    return appointmentTypes.isEmpty
        ? CircularProgressIndicator()
        : Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.surfaceContainerLowest),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedAppointmentType,
                isExpanded: true,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: colorScheme.primary,
                ),
                items: appointmentTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(
                      type,
                      style: TextStyle(
                        fontSize: 16,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedAppointmentType = newValue;
                    });
                  }
                },
              ),
            ),
          );
  }

  Widget _buildSelectChild(colorScheme) {
    return children.isEmpty
        ? CircularProgressIndicator()
        : Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.surfaceContainerLowest),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: selectedChildId,
                isExpanded: true,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: colorScheme.primary,
                ),
                items: children.map((type) {
                  return DropdownMenuItem<int>(
                    value: type.childId,
                    child: Text(
                      '${type.firstName} ${type.lastName}',
                      style: TextStyle(
                        fontSize: 16,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedChildId = newValue;
                    });
                  }
                },
              ),
            ),
          );
  }

  void _showCancelDialog(BuildContext context) async {
    final shouldProceed = await CustomConfirmDialog.show(
      context,
      icon: Icons.error,
      title: 'Cancel Appointment',
      content:
          'Are you sure you want to cancel this appointment? This action cannot be undone.',
      confirmText: 'Cancel',
      cancelText: 'Keep Appointment',
    );

    if (shouldProceed == true) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _confirmAppointment(BuildContext context) async {
    setState(() {
      _isSubmitting = true;
    });

    if (selectedAppointmentType == null || selectedChildId == null) {
      return CustomSnackbar.show(
        context,
        message: 'Please select required field.',
        type: SnackbarType.error,
      );
    }

    final shouldProceed = await CustomConfirmDialog.show(
      context,
      iconBackgroundColor: AppColors.accentDeepMauve,
      icon: Icons.info,
      title: 'Schedule Appointment',
      content: 'Are you sure you want to schedule this appointment?',
      confirmText: 'Schedule',
      cancelText: 'Cancel',
    );

    if (shouldProceed != true) return;

    try {
      final request = AppointmentInsertRequest(
        clientId: widget.clientId,
        childId: selectedChildId!,
        employeeAvailabilityId: widget.availability.employeeAvailabilityId,
        appointmentType: selectedAppointmentType!,
        attendanceStatusId: 1,
        date: widget.selectedDate,
      );

      final response = await appointmentProvider.scheduleAppointment(request);

      if (response == null) {
        CustomSnackbar.show(
          context,
          message:
              'Sorry, we couldn\'t schedule your appointment. Please try again or contact support.',
          type: SnackbarType.error,
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AppointmentSuccessScreen(appointment: response),
          ),
        );
      }
    } catch (e) {
      CustomSnackbar.show(
        context,
        message:
            'Sorry, we couldn\'t schedule your appointment. Please try again or contact support.',
        type: SnackbarType.error,
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  Widget _buildReminder(colorScheme) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.secondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.primary),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: colorScheme.primary, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Important Reminder',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'You are about to request this appointment. The employee will review and confirm it. Please note that the appointment is not final until confirmed by employee.',
                  style: TextStyle(fontSize: 14, color: colorScheme.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          PrimaryButton(
            label: 'Confirm Appointment',
            icon: Icons.check_circle,
            isLoading: false,
            type: ButtonType.filled,
            onPressed: _isSubmitting
                ? null
                : () => _confirmAppointment(context),
          ),

          SizedBox(height: 12),

          PrimaryButton(
            label: 'Cancel',
            type: ButtonType.outlined,
            backgroundColor: colorScheme.onSurface,
            onPressed: _isSubmitting
                ? null
                : () {
                    _showCancelDialog(context);
                  },
          ),
        ],
      ),
    );
  }
}
