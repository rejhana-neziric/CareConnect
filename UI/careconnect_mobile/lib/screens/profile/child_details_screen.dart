import 'package:careconnect_mobile/models/auth_user.dart';
import 'package:careconnect_mobile/models/enums/appointment_status.dart';
import 'package:careconnect_mobile/models/responses/appointment.dart';
import 'package:careconnect_mobile/models/responses/child.dart';
import 'package:careconnect_mobile/providers/appointment_provider.dart';
import 'package:careconnect_mobile/providers/auth_provider.dart';
import 'package:careconnect_mobile/providers/child_provider.dart';
import 'package:careconnect_mobile/providers/client_provider.dart';
import 'package:careconnect_mobile/providers/clients_child_provider.dart';
import 'package:careconnect_mobile/screens/appointment_details_screen.dart';
import 'package:careconnect_mobile/screens/login_screen.dart';
import 'package:careconnect_mobile/screens/profile/edit_child_screen.dart';
import 'package:careconnect_mobile/widgets/confim_dialog.dart';
import 'package:careconnect_mobile/widgets/primary_button.dart';
import 'package:careconnect_mobile/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChildDetailsScreen extends StatefulWidget {
  final Child child;

  const ChildDetailsScreen({super.key, required this.child});

  @override
  State<ChildDetailsScreen> createState() => _ChildDetailsScreenState();
}

class _ChildDetailsScreenState extends State<ChildDetailsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool isLoading = false;

  late Child _child;

  late AppointmentProvider appointmentProvider;
  late ChildProvider childProvider;
  late ClientsChildProvider clientsChildProvider;
  late ClientProvider clientProvider;

  List<Appointment> appointments = [];

  AuthUser? currentUser;

  List<Child>? otherChildren;

  @override
  void initState() {
    super.initState();

    final auth = Provider.of<AuthProvider>(context, listen: false);

    currentUser = auth.user;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();

    _child = widget.child;

    appointmentProvider = context.read<AppointmentProvider>();
    childProvider = context.read<ChildProvider>();
    clientsChildProvider = context.read<ClientsChildProvider>();
    clientProvider = context.read<ClientProvider>();

    _loadAppointments();
    _getChildren();
  }

  Future<void> _loadAppointments() async {
    setState(() {
      isLoading = true;
    });

    final response = await appointmentProvider.loadData(
      childId: widget.child.childId,
    );

    setState(() {
      appointments = response?.result ?? [];
      isLoading = false;
    });
  }

  dynamic _getChildren() async {
    dynamic children;

    if (currentUser != null) {
      children = await clientsChildProvider.getChildren(currentUser!.id);
    }

    setState(() {
      otherChildren = children;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLow,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildAppBar(context, colorScheme),
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    _buildChildInfoCard(colorScheme),
                    const SizedBox(height: 20),
                    _buildAppointmentsSection(colorScheme),
                    const SizedBox(height: 20),
                    _buildDeleteChildInformation(colorScheme),
                    const SizedBox(height: 20),
                    _buildActionButtons(colorScheme),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colorScheme.primary, colorScheme.secondary],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Text(
            '${_child.firstName} ${_child.lastName}',
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 25),
          ),
          const SizedBox(height: 4),
          Text(
            '${_child.age} years old',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildInfoCard(ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            _buildInfoRow(
              icon: Icons.person_outline,
              label: 'Full Name',
              value: '${_child.firstName} ${_child.lastName}',
              colorScheme,
            ),
            const SizedBox(height: 20),
            _buildInfoRow(
              icon: Icons.cake_outlined,
              label: 'Birth Date',
              value: DateFormat('d. MM. yyyy.').format(_child.birthDate),
              colorScheme,
            ),
            const SizedBox(height: 20),
            _buildInfoRow(
              icon: Icons.wc,
              label: 'Gender',
              value: _child.gender,
              colorScheme,
            ),
            const SizedBox(height: 20),
            _buildInfoRow(
              icon: Icons.calendar_today_outlined,
              label: 'Age',
              value: '${_child.age} years old',
              colorScheme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    ColorScheme colorScheme, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
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
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
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

  Widget _buildAppointmentsSection(ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Recent Appointments',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.secondary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${appointments.length}',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (isLoading)
              Center(child: CircularProgressIndicator())
            else if (appointments.isEmpty)
              _buildEmptyAppointments(colorScheme)
            else
              ...appointments
                  .take(3)
                  .map(
                    (appointment) =>
                        _buildAppointmentTile(appointment, colorScheme),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyAppointments(ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.event_note_outlined,
              size: 30,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No appointments yet',
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Appointments will appear here once scheduled',
            style: TextStyle(fontSize: 14, color: colorScheme.onSurface),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentTile(
    Appointment appointment,
    ColorScheme colorScheme,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _viewAppointmentInfo(appointment),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: appointmentStatusFromString(
                  appointment.stateMachine ?? '',
                ).backgroundColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appointment.appointmentType,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('d. MM. yyyy.').format(appointment.date),
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  void _viewAppointmentInfo(Appointment appointment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AppointmentDetailsScreen(appointment: appointment),
      ),
    );
  }

  Widget _buildDeleteChildInformation(colorScheme) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delete Child Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Deleting this child\'s information is permanent and cannot be undone. '
            'All related data will be permanently removed and cannot be recovered.',
            style: TextStyle(fontSize: 14, color: colorScheme.onSurface),
          ),
          const SizedBox(height: 16),

          PrimaryButton(
            label: 'Delete',
            icon: Icons.delete_forever,
            backgroundColor: Colors.red[600],
            onPressed: confirmDelete,
          ),
        ],
      ),
    );
  }

  void confirmDelete() async {
    if (otherChildren?.length != 1) {
      final confirm = await CustomConfirmDialog.show(
        context,
        icon: Icons.warning,
        iconBackgroundColor: Colors.red,
        title: 'Delete Information',
        content:
            'Are you sure you want to delete child\'s information?\n\n'
            'All related data will be permanently removed and cannot be recovered.',
        confirmText: 'Delete',
        cancelText: 'Cancel',
      );

      if (confirm) {
        final success = await _deleteInformation();

        if (!mounted) return;

        CustomSnackbar.show(
          context,
          message: success
              ? 'You have deleted child\'s information.'
              : 'Failed to deactivate account. Please try again later.',
          type: success ? SnackbarType.success : SnackbarType.error,
        );

        Navigator.pop(context);
      }
    } else {
      final shouldProceed = await CustomConfirmDialog.show(
        context,
        icon: Icons.info,

        title: 'Delete Information',
        content:
            'Are you sure you want to delete child\'s information? Deleting this child will also deactivate your account!',
        confirmText: 'Delete',
        cancelText: 'Cancel',
      );

      if (shouldProceed != true) return;

      final success = await clientProvider.delete(currentUser!.id);

      if (!mounted) return;

      CustomSnackbar.show(
        context,
        message: success
            ? 'Client and child successfully deleted.'
            : 'Something went wrong. Please try again.',
        type: success ? SnackbarType.success : SnackbarType.error,
      );

      if (success) {
        final auth = Provider.of<AuthProvider>(context, listen: false);
        auth.logout();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );

        Navigator.of(context).pop(success);
      }
    }
  }

  Future<bool> _deleteInformation() async {
    final success = await clientsChildProvider.removeChildFromClient(
      currentUser!.id,
      widget.child.childId,
    );

    return success;
  }

  Widget _buildActionButtons(ColorScheme colorScheme) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: PrimaryButton(
            label: 'Edit',
            isLoading: false,
            type: ButtonType.filled,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditChildScreen(
                    child: _child,
                    onChildUpdated: (updatedChild) async {
                      await childProvider.update(
                        widget.child.childId,
                        updatedChild,
                      );

                      final refreshed = await childProvider.getById(
                        widget.child.childId,
                      );

                      setState(() {
                        _child = refreshed;
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
