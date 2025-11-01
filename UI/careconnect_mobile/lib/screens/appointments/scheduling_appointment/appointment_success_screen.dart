import 'package:careconnect_mobile/core/layouts/master_screen.dart';
import 'package:careconnect_mobile/models/requests/appointment_insert_request.dart';
import 'package:careconnect_mobile/screens/home_screen.dart';
import 'package:careconnect_mobile/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentSuccessScreen extends StatelessWidget {
  final AppointmentInsertRequest appointment;
  final bool? isRescheduling;

  const AppointmentSuccessScreen({
    super.key,
    required this.appointment,
    this.isRescheduling = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLow,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Success Icon
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF4CAF50).withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.check,
                        color: colorScheme.surfaceContainerLowest,
                        size: 60,
                      ),
                    ),

                    SizedBox(height: 32),

                    // Success Message
                    Text(
                      isRescheduling == true
                          ? 'Appointment Reschedule Pending'
                          : 'Appointment Scheduled!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 12),

                    Text(
                      isRescheduling == true
                          ? 'You have successfully requested new appointment time.The employee will review and confirm it. Please note that the appointment is not final until confirmed by employee. '
                          : 'Your appointment has been successfully scheduled. The employee will review and confirm it. Please note that the appointment is not final until confirmed by employee.',
                      style: TextStyle(
                        fontSize: 16,
                        color: colorScheme.onSurface,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 40),

                    // Appointment Details Card
                    _buildAppointmentDetailsCard(colorScheme),
                  ],
                ),
              ),

              PrimaryButton(
                label: 'Back to Home',
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (_) => EmployeeListScreen()),
                  // );

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MasterScreen('Home', HomeScreen()),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentDetailsCard(colorScheme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
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
        children: [
          Text(
            'Appointment Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 20),

          _buildDetailRow(
            'Date & Time',
            DateFormat(
              'EEEE, d MMMM, y \'at\' h:mm a',
            ).format(appointment.date),
            colorScheme,
          ),
          SizedBox(height: 16),

          _buildDetailRow('Type', appointment.appointmentType, colorScheme),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, ColorScheme colorScheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
