import 'package:careconnect_mobile/core/theme/app_colors.dart';
import 'package:careconnect_mobile/models/auth_user.dart';
import 'package:careconnect_mobile/models/responses/child.dart';
import 'package:careconnect_mobile/models/responses/workshop.dart';
import 'package:careconnect_mobile/providers/auth_provider.dart';
import 'package:careconnect_mobile/providers/client_provider.dart';
import 'package:careconnect_mobile/providers/clients_child_provider.dart';
import 'package:careconnect_mobile/providers/payment_provider.dart';
import 'package:careconnect_mobile/providers/workshop_provider.dart';
import 'package:careconnect_mobile/widgets/confim_dialog.dart';
import 'package:careconnect_mobile/widgets/primary_button.dart';
import 'package:careconnect_mobile/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WorkshopDetailsScreen extends StatefulWidget {
  final Workshop workshop;
  const WorkshopDetailsScreen({super.key, required this.workshop});

  @override
  State<WorkshopDetailsScreen> createState() => _WorkshopDetailsScreenState();
}

class _WorkshopDetailsScreenState extends State<WorkshopDetailsScreen> {
  late WorkshopProvider workshopProvider;
  late ClientsChildProvider clientsChildProvider;
  late PaymentProvider paymentProvider;
  late ClientProvider clientProvider;

  AuthUser? currentUser;

  List<Child> children = [];
  int? selectedChildId;

  bool _isEnrolled = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    final auth = Provider.of<AuthProvider>(context, listen: false);

    currentUser = auth.user;

    workshopProvider = context.read<WorkshopProvider>();
    clientsChildProvider = context.read<ClientsChildProvider>();
    paymentProvider = context.read<PaymentProvider>();
    clientProvider = context.read<ClientProvider>();

    // check if client is already enrolled
    if (widget.workshop.workshopType == "Parents") {
      _checkEnrollmentStatus();
    }
  }

  Future<void> _checkEnrollmentStatus() async {
    if (currentUser == null) return;

    try {
      final isEnrolled = await workshopProvider.isEnrolledInWorkshop(
        workshopId: widget.workshop.workshopId,
        clientId: currentUser!.id,
        childId: null,
      );
      setState(() {
        _isEnrolled = isEnrolled;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLow,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.surfaceContainerLow,
        foregroundColor: colorScheme.onSurface,
        title: Text(
          'Workshops Details',
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
            _buildWorkshopInfo(colorScheme),
            _buildDateTimeCard(colorScheme),
            const SizedBox(height: 16),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildBottomBar(colorScheme),
      ),
    );
  }

  Widget _buildWorkshopInfo(ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.workshop.name,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '- Workshop for ${widget.workshop.workshopType}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          _buildWorkshopSpots(colorScheme),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildPriceCard(
                'Regular price',
                widget.workshop.price,
                Icons.attach_money,
                colorScheme,
              ),
              const SizedBox(width: 12),
              if (widget.workshop.memberPrice != null)
                _buildPriceCard(
                  'Member price',
                  widget.workshop.memberPrice,
                  Icons.card_membership,
                  colorScheme,
                ),
            ],
          ),
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
            widget.workshop.description,
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onSurface,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceCard(
    String label,
    double? price,
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
                  price != null ? '\$${price.toStringAsFixed(2)}' : 'Free',
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

  Widget _buildDateTimeCard(ColorScheme colorScheme) {
    final startDate = widget.workshop.startDate;
    final endDate = widget.workshop.endDate;

    return Container(
      padding: const EdgeInsets.all(24),
      margin: EdgeInsets.symmetric(horizontal: 24),

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
          _buildDateInfo(colorScheme, 'Start date', startDate),
          if (endDate != null) ...[
            const Divider(height: 32),
            _buildDateInfo(colorScheme, 'End date', endDate),
          ],
        ],
      ),
    );
  }

  Widget _buildDateInfo(ColorScheme colorScheme, String title, DateTime date) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.only(left: 20),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Icon(
            Icons.calendar_month,
            color: colorScheme.primary,
            size: 25,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
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
    );
  }

  Widget _buildWorkshopSpots(ColorScheme colorScheme) {
    if ((widget.workshop.maxParticipants == null &&
            widget.workshop.participants == null) ||
        widget.workshop.participants == null) {
      return SizedBox.shrink();
    }

    final available =
        widget.workshop.maxParticipants! - widget.workshop.participants!;
    final progress =
        (widget.workshop.participants! / widget.workshop.maxParticipants!)
            .clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Available spots: $available / ${widget.workshop.maxParticipants}",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 12,
                backgroundColor: colorScheme.surfaceVariant,
                valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(ColorScheme colorScheme) {
    if (widget.workshop.maxParticipants != null &&
        widget.workshop.participants != null &&
        widget.workshop.participants! >= widget.workshop.maxParticipants!) {
      return SizedBox.shrink();
    }

    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (_isEnrolled) {
      return PrimaryButton(
        label: 'You are already enrolled',
        onPressed: () {
          CustomSnackbar.show(
            context,
            message: 'You have already enrolled to this workshop.',
            type: SnackbarType.info,
          );
        },
      );
    } else {
      return PrimaryButton(
        label: widget.workshop.price == null
            ? 'Enroll for Free'
            : 'Pay & Enroll (\$${widget.workshop.price.toString()})',
        onPressed: _handleEnrollment,
      );
    }
  }

  Future<void> _handleEnrollment() async {
    if (currentUser == null) return;

    List<Child> children = [];

    if (widget.workshop.workshopType == "Children") {
      children = await clientsChildProvider.getChildren(currentUser!.id);
    }

    int? selectedChildId;

    if (children.isNotEmpty && children.length > 1) {
      selectedChildId = await _showChildSelectionDialog(context, children);

      if (selectedChildId == null) return;
    } else if (children.length == 1) {
      selectedChildId = children.first.childId;
    }

    final isChildEnrolled = await workshopProvider.isEnrolledInWorkshop(
      workshopId: widget.workshop.workshopId,
      clientId: currentUser!.id,
      childId: selectedChildId,
    );

    if (isChildEnrolled) {
      return CustomSnackbar.show(
        context,
        message: 'Your child is already enrolled to this workshop.',
        type: SnackbarType.info,
      );
    }

    final shouldProceed = await CustomConfirmDialog.show(
      context,
      iconBackgroundColor: AppColors.accentDeepMauve,
      icon: Icons.info,
      title: 'Confirm',
      content: 'Are you sure you want to enroll in this workshop?',
      confirmText: 'Enroll',
      cancelText: 'Cancel',
    );

    if (shouldProceed != true) return;

    bool result;

    try {
      if (widget.workshop.price == null) {
        result = await workshopProvider.enrollInFreeItem(
          context: context,
          workshopId: widget.workshop.workshopId,
          clientId: currentUser!.id,
          childId: selectedChildId,
        );
      } else {
        final client = await clientProvider.getById(currentUser!.id);

        result = await workshopProvider.processPayment(
          context: context,
          workshopId: widget.workshop.workshopId,
          clientId: currentUser!.id,
          childId: selectedChildId,
          amount: widget.workshop.price!,
          client: client,
        );
      }

      if (result == true) {
        if (!mounted) return;

        Navigator.pop(context);

        Future.microtask(() {
          if (mounted) {
            CustomSnackbar.show(
              context,
              message: 'Successfully enrolled in workshop!',
              type: SnackbarType.success,
            );
          }
        });
      } else {
        if (!mounted) return;
        CustomSnackbar.show(
          context,
          message:
              'Failed to enroll. Workshop may be full or you have already enrolled.',
          type: SnackbarType.info,
        );
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop();

      CustomSnackbar.show(
        context,
        message: 'Something went wrong. Please try again.',
        type: SnackbarType.info,
      );
    }
  }

  Future<int?> _showChildSelectionDialog(
    BuildContext context,
    List<Child> children,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                "Select child you want to enroll",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: children.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final child = children[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: colorScheme.secondary,
                        child: Text(
                          child.firstName[0],
                          style: TextStyle(color: colorScheme.primary),
                        ),
                      ),
                      title: Text('${child.firstName} ${child.lastName}'),
                      onTap: () => Navigator.pop(context, child.childId),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
