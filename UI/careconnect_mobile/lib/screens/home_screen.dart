import 'package:careconnect_mobile/models/auth_user.dart';
import 'package:careconnect_mobile/models/responses/appointment.dart';
import 'package:careconnect_mobile/providers/appointment_provider.dart';
import 'package:careconnect_mobile/providers/auth_provider.dart';
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

  late AppointmentProvider appointmentProvider;

  List<Appointment> appointments = [];

  AuthUser? currentUser;

  @override
  void initState() {
    super.initState();

    appointmentProvider = context.read<AppointmentProvider>();

    final auth = Provider.of<AuthProvider>(context, listen: false);

    setState(() {
      currentUser = auth.user;
    });

    loadAppointments();
  }

  Future<void> loadAppointments() async {
    setState(() {
      isLoading = true;
    });

    final response = await appointmentProvider.loadData(
      clientUsername: currentUser?.username,
    );

    setState(() {
      appointments = response?.result ?? [];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    // final colorScheme = theme.colorScheme;

    // return MasterScreen(
    //   "Hi, ${currentUser?.username}",

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Appointments',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          _buildMyAppointments(),
          _buildMyWorkshops(),
        ],
      ),
    );
    //   ),
    // );
  }

  Widget _buildMyAppointments() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (appointments.isEmpty) {
      return const Center(
        child: Text(
          "No appointments available",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: appointments.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          return _buildAppointmentCard(appointment);
        },
      ),
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    return SizedBox(
      width: 300,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF0E0),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${appointment.employeeAvailability?.employee.user?.firstName} ${appointment.employeeAvailability?.employee.user?.lastName}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    appointment.employeeAvailability?.employee.jobTitle ?? "",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 12),

                  Text(appointment.employeeAvailability?.service?.name ?? ""),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      const Icon(
                        Icons.date_range,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          DateFormat('d. M. y.').format(appointment.date),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          '${appointment.employeeAvailability?.startTime} - ${appointment.employeeAvailability?.endTime}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Right arrow
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildMyWorkshops() {
    return SizedBox(width: 20);
  }
}
