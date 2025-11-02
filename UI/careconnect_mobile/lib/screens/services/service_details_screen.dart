import 'package:careconnect_mobile/models/auth_user.dart';
import 'package:careconnect_mobile/models/responses/employee.dart';
import 'package:careconnect_mobile/models/responses/service.dart';
import 'package:careconnect_mobile/providers/auth_provider.dart';
import 'package:careconnect_mobile/providers/permission_provider.dart';
import 'package:careconnect_mobile/providers/service_provider.dart';
import 'package:careconnect_mobile/screens/no_permission_screen.dart';
import 'package:careconnect_mobile/screens/appointments/scheduling_appointment/appointment_scheduling_screen.dart';
import 'package:careconnect_mobile/screens/services/employee_profile_screen.dart';
import 'package:careconnect_mobile/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final Service service;

  const ServiceDetailsScreen({super.key, required this.service});

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen>
    with SingleTickerProviderStateMixin {
  late ServiceProvider serviceProvider;

  List<Employee>? employees;

  AuthUser? currentUser;

  @override
  void initState() {
    super.initState();

    final auth = Provider.of<AuthProvider>(context, listen: false);

    currentUser = auth.user;

    serviceProvider = context.read<ServiceProvider>();

    final permissionProvider = context.read<PermissionProvider>();

    if (permissionProvider.canGetEmployeesForService()) loadEmployees();
  }

  void loadEmployees() async {
    final response = await serviceProvider.getAvailableEmployees(
      widget.service.serviceId,
    );

    setState(() {
      employees = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final permissionProvider = context.read<PermissionProvider>();

    if (!permissionProvider.canGetByIdService()) {
      return Scaffold(
        backgroundColor: colorScheme.surfaceContainerLow,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: colorScheme.surfaceContainerLow,
          foregroundColor: colorScheme.onSurface,
          title: Text(
            'Service Details',
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
          'Service Details',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: colorScheme.onSurface,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildServiceInfo(colorScheme),
            if (permissionProvider.canGetEmployeesForService())
              _buildEmployeesTab(colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceInfo(ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.service.name,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),

          const SizedBox(height: 16),
          Text(
            widget.service.serviceType?.name ?? '',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPriceCard(
                'Regular price',
                widget.service.price?.toStringAsFixed(2),
                Icons.attach_money,
                colorScheme,
              ),
            ],
          ),
          if (widget.service.description != null) ...[
            const SizedBox(height: 20),
            Text(
              'Description',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.service.description!,
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.onSurface,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPriceCard(
    String label,
    String? price,
    IconData icon,
    ColorScheme colorScheme,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.surfaceContainerLowest),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: colorScheme.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  price != null ? price : 'Not provided',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeesTab(ColorScheme colorScheme) {
    if (employees == null || employees?.isEmpty == true) {
      return Text('No current available employee, please connact support.');
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      itemCount: employees!.length,
      itemBuilder: (context, index) {
        final employee = employees![index];
        return _buildEmployeeCard(employee, colorScheme);
      },
    );
  }

  Widget _buildEmployeeCard(Employee employee, ColorScheme colorScheme) {
    final permissionProvider = context.read<PermissionProvider>();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${employee.user?.firstName} ${employee.user?.lastName}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Available',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),
                    Text(
                      employee.jobTitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () =>
                      permissionProvider.canScheduleAppointment() == true
                      ? _scheduleAppointment(employee)
                      : _showNoPermission(),
                  icon: const Icon(Icons.calendar_today, size: 18),
                  label: const Text('Schedule'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onSurface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () => _viewProfile(employee),
                icon: const Icon(Icons.person, size: 18),
                label: const Text('Profile'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorScheme.primary,
                  side: BorderSide(color: colorScheme.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showNoPermission() {
    CustomSnackbar.show(
      context,
      message:
          'Sorry, you do not have permission to perform this action. Contact administration.',
      type: SnackbarType.error,
    );
  }

  void _scheduleAppointment(Employee employee) {
    if (currentUser == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppointmentSchedulingScreen(
          clientId: currentUser!.id,
          childId: 1,
          employee: employee,
          service: widget.service,
        ),
      ),
    );
  }

  void _viewProfile(Employee employee) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EmployeeProfileScreen(employee: employee, service: widget.service),
      ),
    );
  }
}
