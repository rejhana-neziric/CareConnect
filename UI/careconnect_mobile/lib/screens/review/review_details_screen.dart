import 'package:careconnect_mobile/core/theme/app_colors.dart';
import 'package:careconnect_mobile/models/auth_user.dart';
import 'package:careconnect_mobile/models/requests/review_insert_request.dart';
import 'package:careconnect_mobile/models/requests/review_update_request.dart';
import 'package:careconnect_mobile/models/responses/appointment.dart';
import 'package:careconnect_mobile/models/responses/employee.dart';
import 'package:careconnect_mobile/models/responses/review.dart';
import 'package:careconnect_mobile/providers/appointment_provider.dart';
import 'package:careconnect_mobile/providers/auth_provider.dart';
import 'package:careconnect_mobile/widgets/confim_dialog.dart';
import 'package:careconnect_mobile/widgets/custom_text_field.dart';
import 'package:careconnect_mobile/widgets/primary_button.dart';
import 'package:careconnect_mobile/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class ReviewDetailsScreen extends StatefulWidget {
  final Review? review;
  final Function(ReviewUpdateRequest)? onReviewUpdated;
  final Function(ReviewInsertRequest)? onReviewInserted;

  const ReviewDetailsScreen({
    super.key,
    this.review,
    this.onReviewUpdated,
    this.onReviewInserted,
  });

  @override
  State<ReviewDetailsScreen> createState() => _ReviewDetailsScreenState();
}

class _ReviewDetailsScreenState extends State<ReviewDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  late bool isEditing;

  late AppointmentProvider appointmentProvider;

  Map<String, dynamic> _initialValue = {};

  int? _stars;

  AuthUser? currentUser;

  List<Employee> employees = [];
  List<Appointment> appointments = [];

  @override
  void initState() {
    super.initState();

    final auth = Provider.of<AuthProvider>(context, listen: false);

    currentUser = auth.user;

    appointmentProvider = context.read<AppointmentProvider>();

    loadAppointments();

    isEditing = widget.review == null ? false : true;

    if (isEditing && widget.review != null) {
      _initialValue = {
        'title': widget.review?.title,
        'content': widget.review?.content,
      };

      _stars = widget.review?.stars;
    }
  }

  void loadAppointments() async {
    final response = await appointmentProvider.loadData(status: 'Completed');

    appointments = response?.result ?? [];

    employees = getCompletedEmployees(appointments, currentUser!.id);
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

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLow,
      appBar: AppBar(
        backgroundColor: colorScheme.surfaceContainerLow,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        title: Text(
          isEditing ? 'Edit Review' : 'Add New Review',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: FormBuilder(
        key: _formKey,
        initialValue: _initialValue,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildFormCard(colorScheme),
              const SizedBox(height: 30),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEditing ? 'Update Details' : 'Review Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Column(
                children: [
                  if (!isEditing) ...[
                    FormBuilderDropdown<int>(
                      name: 'employeeId',
                      initialValue: null,
                      decoration: InputDecoration(
                        labelText: 'Select Employee',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: FormBuilderValidators.required(),
                      items: employees
                          .map(
                            (employee) => DropdownMenuItem<int>(
                              value: employee.user?.userId,
                              child: Text(
                                '${employee.user?.firstName} ${employee.user?.lastName}',
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Reviews can only be added for employees from completed appointments.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],

                  const SizedBox(height: 20),

                  RatingBar.builder(
                    initialRating: _stars?.toDouble() ?? 0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemSize: 36,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) =>
                        const Icon(Icons.star, color: Colors.amber),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _stars = rating.toInt();
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _stars != null
                        ? "You selected $_stars star(s)"
                        : "No rating yet",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            CustomTextField(
              name: 'title',
              label: 'Title',
              maxLines: 2,
              icon: Icons.title,
              validators: [
                FormBuilderValidators.required(errorText: 'Title is required.'),
                FormBuilderValidators.minLength(
                  2,
                  errorText: 'Title must be at least 2 characters.',
                ),
                FormBuilderValidators.maxLength(
                  50,
                  errorText: 'Title must not exceed 50 characters.',
                ),
              ],
            ),

            const SizedBox(height: 20),

            CustomTextField(
              name: 'content',
              label: 'Content',
              maxLines: 10,
              icon: Icons.note,
              validators: [
                FormBuilderValidators.required(
                  errorText: 'Content is required.',
                ),
                FormBuilderValidators.minLength(
                  2,
                  errorText: 'Content must be at least 2 characters.',
                ),
                FormBuilderValidators.maxLength(
                  300,
                  errorText: 'Content must not exceed 300 characters.',
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        PrimaryButton(
          label: 'Save',
          isLoading: false,
          type: ButtonType.filled,
          onPressed: _save,
        ),
        const SizedBox(height: 12),
        PrimaryButton(
          label: 'Cancel',
          type: ButtonType.outlined,
          backgroundColor: colorScheme.onSurface,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Future<void> _save() async {
    if (currentUser == null) return;

    final formState = _formKey.currentState;

    if (formState == null || !formState.saveAndValidate()) {
      debugPrint('Form is not valid or state is null');
      return;
    }

    final shouldProceed = await CustomConfirmDialog.show(
      context,
      iconBackgroundColor: AppColors.accentDeepMauve,
      icon: Icons.info,
      title: isEditing ? 'Edit' : 'Add',
      content: isEditing
          ? 'Are you sure you want to save changes?'
          : 'Are you sure you want to add new review?',
      confirmText: 'Save',
      cancelText: 'Cancel',
    );

    if (shouldProceed != true) return;

    if (mounted) {
      setState(() {});
    }
    try {
      final formData = _formKey.currentState?.value;

      if (formData == null) {
        return;
      }

      final request = isEditing
          ? ReviewUpdateRequest(
              title: formData['title'],
              content: formData['content'],
              stars: _stars,
            )
          : ReviewInsertRequest(
              title: formData['title'],
              content: formData['content'],
              stars: _stars,
              userId: currentUser!.id,
              employeeId: formData['employeeId'],
            );

      if (isEditing) {
        widget.onReviewUpdated!(request as ReviewUpdateRequest);
      } else {
        widget.onReviewInserted!(request as ReviewInsertRequest);
      }

      if (mounted) {
        CustomSnackbar.show(
          context,
          message: isEditing
              ? 'Review details updated successfully!'
              : 'Successfully added new review!',
          type: SnackbarType.success,
        );

        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar.show(
          context,
          message: 'Something went wrong. Please try again.',
          type: SnackbarType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {});
      }
    }
  }
}
