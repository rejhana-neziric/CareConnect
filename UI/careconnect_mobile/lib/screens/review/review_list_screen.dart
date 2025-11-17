import 'package:careconnect_mobile/models/auth_user.dart';
import 'package:careconnect_mobile/models/responses/appointment.dart';
import 'package:careconnect_mobile/models/responses/employee.dart';
import 'package:careconnect_mobile/models/responses/review.dart';
import 'package:careconnect_mobile/providers/appointment_provider.dart';
import 'package:careconnect_mobile/providers/auth_provider.dart';
import 'package:careconnect_mobile/providers/permission_provider.dart';
import 'package:careconnect_mobile/providers/review_provider.dart';
import 'package:careconnect_mobile/screens/no_permission_screen.dart';
import 'package:careconnect_mobile/screens/review/review_details_screen.dart';
import 'package:careconnect_mobile/widgets/confim_dialog.dart';
import 'package:careconnect_mobile/widgets/primary_button.dart';
import 'package:careconnect_mobile/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ReviewListScreen extends StatefulWidget {
  const ReviewListScreen({super.key});

  @override
  State<ReviewListScreen> createState() => _ReviewListScreenState();
}

class _ReviewListScreenState extends State<ReviewListScreen> {
  List<Review> reviews = [];
  bool _isLoading = false;

  AuthUser? currentUser;

  List<Employee> employees = [];
  List<Appointment> appointments = [];

  late ReviewProvider reviewProvider;
  late AppointmentProvider appointmentProvider;

  @override
  void initState() {
    super.initState();

    final auth = Provider.of<AuthProvider>(context, listen: false);

    currentUser = auth.user;

    reviewProvider = context.read<ReviewProvider>();
    appointmentProvider = context.read<AppointmentProvider>();

    final permissionProvider = context.read<PermissionProvider>();

    if (permissionProvider.canGetReviews()) loadReviews();
    loadAppointments();
  }

  Future<void> loadReviews() async {
    setState(() => _isLoading = true);
    try {
      if (currentUser == null) return;

      final response = await reviewProvider.loadData(
        userId: currentUser!.id,
        isHidden: false,
      );

      reviews = response?.result ?? [];

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading reviews: ${e.toString()}')),
        );
      }
    }
  }

  void loadAppointments() async {
    setState(() => _isLoading = true);
    final response = await appointmentProvider.loadData(status: 'Completed');

    appointments = response?.result ?? [];

    employees = getCompletedEmployees(appointments, currentUser!.id);

    setState(() => _isLoading = false);
  }

  List<Employee> getCompletedEmployees(
    List<Appointment> appointments,
    int clientId,
  ) {
    final filtered = appointments.where((a) {
      return a.clientId == clientId;
    }).toList();

    final employees = filtered
        .map((a) => a.employeeAvailability?.employee)
        .where((e) => e != null)
        .cast<Employee>()
        .toSet()
        .toList();

    return employees;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final permissionProvider = context.read<PermissionProvider>();

    if (!permissionProvider.canGetReviews()) {
      return Scaffold(
        backgroundColor: colorScheme.surfaceContainerLow,
        body: NoPermissionScreen(),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLow,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadReviews,
              child: Column(
                children: [
                  Expanded(
                    child: reviews.isEmpty
                        ? _buildEmptyState(colorScheme)
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: reviews.length,
                            itemBuilder: (context, index) {
                              return _buildReviewCard(
                                reviews[index],
                                colorScheme,
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),

      // bottomNavigationBar: Padding(
      //   padding: EdgeInsetsGeometry.symmetric(vertical: 12, horizontal: 8),
      //   child: _buildBottomBar(colorScheme),
      // ),
      bottomNavigationBar: permissionProvider.canInsertReview()
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: _buildBottomBar(colorScheme),
            )
          : null,
    );
  }

  Widget _buildReviewCard(Review review, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  review.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                    color: colorScheme.primary,
                  ),
                ),
                if (review.stars != null) _buildStars(review.stars!),
              ],
            ),

            SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  "Employee: ${review.employee?.user?.firstName} ${review.employee?.user?.lastName}",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),

            SizedBox(height: 10),
            Text(
              review.content,
              style: TextStyle(
                fontSize: 15,
                color: colorScheme.onSurface,
                height: 1.5,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Last edited: ${DateFormat('d. MM. yyyy').format(review.modifiedDate)}',
                  style: TextStyle(fontSize: 13, color: colorScheme.onSurface),
                ),
                _buildActionButtons(review),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStars(int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < count ? Icons.star_rounded : Icons.star_outline_rounded,
          size: 18,
          color: index < count ? Colors.amber[600] : Colors.grey[300],
        );
      }),
    );
  }

  Widget _buildActionButtons(Review review) {
    final permissionProvider = context.read<PermissionProvider>();

    return Row(
      children: [
        if (permissionProvider.canEditReview())
          IconButton(onPressed: () => _edit(review), icon: Icon(Icons.edit)),
        if (permissionProvider.canDeleteReview())
          IconButton(
            onPressed: () => _delete(review),
            icon: Icon(Icons.delete_outline_rounded),
          ),
      ],
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLowest,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.rate_review_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No reviews yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          if (employees.isEmpty)
            Text(
              'You can only add reviews for completed appointments.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  void _addReview() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewDetailsScreen(
          onReviewInserted: (insertedReview) async {
            await reviewProvider.insert(insertedReview);
            loadReviews();
          },
        ),
      ),
    );
  }

  void _edit(Review review) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewDetailsScreen(
          review: review,
          onReviewUpdated: (updatedReview) async {
            await reviewProvider.update(review.reviewId, updatedReview);
            loadReviews();
          },
        ),
      ),
    );
  }

  void _delete(Review review) async {
    final confirm = await CustomConfirmDialog.show(
      context,
      icon: Icons.warning,
      iconBackgroundColor: Colors.red,
      title: 'Delete Review',
      content: 'Are you sure you want to delete review?',
      confirmText: 'Delete',
      cancelText: 'Cancel',
    );

    if (confirm) {
      try {
        final result = await reviewProvider.delete(review.reviewId);

        if (result['success']) {
          CustomSnackbar.show(
            context,
            message: 'You have deleted review.',
            type: SnackbarType.success,
          );

          loadReviews();
        } else {
          CustomSnackbar.show(
            context,
            message: result['message'],
            type: SnackbarType.error,
          );
        }
      } catch (e) {
        CustomSnackbar.show(
          context,
          message: 'Something went wrong. Please try again later.',
          type: SnackbarType.error,
        );
      }
    }
  }

  Widget _buildBottomBar(ColorScheme colorScheme) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (employees.isEmpty) {
      return SizedBox.shrink();
    } else {
      return PrimaryButton(label: 'Add Review', onPressed: _addReview);
    }
  }
}
