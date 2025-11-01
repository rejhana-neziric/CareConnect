import 'package:careconnect_mobile/models/messages/appointment_notification.dart';
import 'package:careconnect_mobile/models/responses/appointment.dart';
import 'package:careconnect_mobile/providers/appointment_provider.dart';
import 'package:careconnect_mobile/providers/notification_provider.dart';
import 'package:careconnect_mobile/screens/appointments/appointment_details_screen.dart';
import 'package:careconnect_mobile/screens/appointments/scheduling_appointment/appointment_scheduling_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late AppointmentProvider appointmentProvider;

  @override
  void initState() {
    super.initState();

    appointmentProvider = context.read<AppointmentProvider>();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLow,
      body: Consumer<NotificationProvider>(
        builder: (context, notificationService, _) {
          final notifications = notificationService.notifications;

          if (notifications.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No notifications yet'),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return NotificationTile(
                notification: notification,
                onTap: () async {
                  if (notification.appointmentId != null) {
                    Appointment appointment = await appointmentProvider.getById(
                      notification.appointmentId!,
                      filter: {
                        'isClientsChildIncluded': true,
                        'isEmployeeAvailabilityIncluded': true,
                        'isAttendanceStatusIncluded': true,
                      },
                    );
                    _handleNotificationTap(context, notification, appointment);
                  }
                },
                onDismiss: () {
                  notificationService.clearNotifications();
                },
              );
            },
          );
        },
      ),
    );
  }

  void _handleNotificationTap(
    BuildContext content,
    AppointmentNotification notification,
    Appointment appointment,
  ) {
    if (notification.title == 'Reschedule for Appointment Requested') {
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
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              AppointmentDetailsScreen(appointment: appointment),
        ),
      );
    }
  }
}

class NotificationTile extends StatelessWidget {
  final AppointmentNotification notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        color: Colors.redAccent,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          color: colorScheme.surfaceContainerLowest,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),

                // Main Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.body,
                        style: TextStyle(
                          fontSize: 14,
                          color: colorScheme.onSurface,
                        ),
                        softWrap: true,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        timeAgo(notification.receivedAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.chevron_right, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    return '${diff.inDays} days ago';
  }
}
