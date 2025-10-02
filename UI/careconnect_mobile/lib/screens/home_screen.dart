import 'package:careconnect_mobile/core/theme/app_colors.dart';
import 'package:careconnect_mobile/models/auth_user.dart';
import 'package:careconnect_mobile/models/responses/appointment.dart';
import 'package:careconnect_mobile/models/responses/workshop.dart';
import 'package:careconnect_mobile/providers/appointment_provider.dart';
import 'package:careconnect_mobile/providers/auth_provider.dart';
import 'package:careconnect_mobile/providers/workshop_provider.dart';
import 'package:careconnect_mobile/screens/appointment_details_screen.dart';
import 'package:careconnect_mobile/screens/my_appointments_screen.dart';
import 'package:careconnect_mobile/screens/my_workshops_screen.dart';
import 'package:careconnect_mobile/screens/workshop_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  bool isLoadingAppointments = false;
  bool isLoadingWorkshops = false;

  late AppointmentProvider appointmentProvider;
  late WorkshopProvider workshopProvider;

  List<Appointment> appointments = [];
  List<Workshop> workshops = [];

  AuthUser? currentUser;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeProviders();
  }

  void _initializeProviders() {
    appointmentProvider = Provider.of<AppointmentProvider>(
      context,
      listen: false,
    );
    workshopProvider = Provider.of<WorkshopProvider>(context, listen: false);

    final auth = Provider.of<AuthProvider>(context, listen: false);
    setState(() {
      currentUser = auth.user;
    });

    loadAppointments();
    loadWorkshops();
  }

  Future<void> loadAppointments() async {
    if (currentUser == null) return;

    setState(() {
      isLoadingAppointments = true;
    });

    try {
      final response = await appointmentProvider.loadData(
        clientId: currentUser!.id,
      );

      setState(() {
        appointments = response?.result ?? [];
      });
    } catch (e) {
      // Handle error appropriately
      print('Error loading appointments: $e');
    } finally {
      setState(() {
        isLoadingAppointments = false;
      });
    }
  }

  Future<void> loadWorkshops() async {
    setState(() {
      isLoadingWorkshops = true;
    });

    try {
      final response = await workshopProvider.loadData(
        participantId: currentUser!.id,
      );

      setState(() {
        workshops = response?.result ?? [];
      });
    } catch (e) {
      // Handle error appropriately
      print('Error loading workshops: $e');
    } finally {
      setState(() {
        isLoadingWorkshops = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colorScheme.primary, colorScheme.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.secondary,
                    blurRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome Back!",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Here’s a quick look at your appointments and workshops.",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsetsGeometry.only(left: 10),
                  child: Text(
                    "My Appointments",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyAppointmentsScreen(),
                      ),
                    ),
                  },
                  label: const Text('All appointments'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.white,
                    backgroundColor: colorScheme.primary,
                    side: BorderSide(color: colorScheme.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 16,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            _buildAppointmentsSection(colorScheme),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsetsGeometry.only(left: 10),
                  child: Text(
                    "My Workshops",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyWorkshopsScreen(),
                      ),
                    ),
                  },
                  label: const Text('All workhops'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.white,
                    backgroundColor: colorScheme.primary,
                    side: BorderSide(color: colorScheme.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            _buildWorkshopsSection(colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentsSection(ColorScheme colorScheme) {
    if (isLoadingAppointments) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (appointments.isEmpty) {
      return SizedBox(
        height: 100,
        child: Center(
          child: Text(
            "No upcoming appointments",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return SizedBox(
      height: 200,
      child: appointments.isEmpty
          ? const Center(
              child: Text(
                "No upcoming appointments",
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: appointments.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                return _buildAppointmentCard(appointment, colorScheme);
              },
            ),
    );
  }

  Widget _buildWorkshopsSection(ColorScheme colorScheme) {
    if (isLoadingWorkshops) {
      return const Center(child: CircularProgressIndicator());
    }

    if (workshops.isEmpty) {
      return const Center(
        child: Text(
          "No workshops available",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return SizedBox(
      height: 180,
      child: workshops.isEmpty
          ? const Center(
              child: Text(
                "No upcoming appointments",
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: workshops.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final workshop = workshops[index];
                return _buildWorkshopCard(workshop, colorScheme);
              },
            ),
    );
  }

  Widget _buildAppointmentCard(
    Appointment appointment,
    ColorScheme colorScheme,
  ) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header row with name and chevron
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${appointment.employeeAvailability?.employee.user?.firstName ?? ''} '
                  '${appointment.employeeAvailability?.employee.user?.lastName ?? ''}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AppointmentDetailsScreen(appointment: appointment),
                      ),
                    );
                  },
                  icon: const Icon(Icons.chevron_right, color: Colors.grey),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 35,
                    minHeight: 35,
                  ),
                ),
              ],
            ),

            Container(
              constraints: const BoxConstraints(minHeight: 40),
              child: Text(
                appointment.employeeAvailability?.service?.name ?? "",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.primary,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Icon(Icons.date_range, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    DateFormat('d. M. y.').format(appointment.date),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            _buildCompactInfoRow(
              Icons.access_time,
              '${appointment.employeeAvailability?.startTime ?? ''} - '
              '${appointment.employeeAvailability?.endTime ?? ''}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildWorkshopCard(Workshop workshop, ColorScheme colorScheme) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        constraints: const BoxConstraints(minHeight: 40),
                        child: Text(
                          workshop.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onSurface,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            WorkshopDetailsScreen(workshop: workshop),
                      ),
                    );
                  },
                  icon: const Icon(Icons.chevron_right, color: Colors.grey),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 35,
                    minHeight: 35,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            _buildWorkshopDetail(
              Icons.date_range,
              workshop.endDate != null
                  ? '${DateFormat('d. MM. yyyy').format(workshop.startDate)} - ${DateFormat('d. MM. yyyy').format(workshop.endDate!)}'
                  : DateFormat('d MMM y').format(workshop.startDate),
            ),

            const SizedBox(height: 8),

            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _buildWorkshopDetail(
                  Icons.attach_money,
                  workshop.price != null ? "\$${workshop.price}" : "Free",
                ),
                _buildWorkshopDetail(
                  Icons.group,
                  "${workshop.participants ?? 0}/${workshop.maxParticipants ?? 0}",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkshopDetail(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
