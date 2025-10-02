import 'package:careconnect_mobile/core/theme/app_colors.dart';
import 'package:careconnect_mobile/models/responses/employee.dart';
import 'package:careconnect_mobile/models/responses/employee_availability.dart';
import 'package:careconnect_mobile/models/responses/review.dart';
import 'package:careconnect_mobile/providers/employee_availability_provider.dart';
import 'package:careconnect_mobile/providers/review_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EmployeeProfileScreen extends StatefulWidget {
  const EmployeeProfileScreen({
    super.key,
    required this.employee,
    required this.serviceId,
  });

  final Employee employee;
  final int serviceId;

  @override
  State<EmployeeProfileScreen> createState() => _EmployeeProfileScreenState();
}

class _EmployeeProfileScreenState extends State<EmployeeProfileScreen> {
  bool isLoading = false;

  late ReviewProvider reviewProvider;
  late EmployeeAvailabilityProvider employeeAvailabilityProvider;

  List<Review> reviews = [];
  List<EmployeeAvailability> availabilities = [];

  double get _averageRating {
    if (reviews.isEmpty) return 0;
    final validReviews = reviews.where((r) => r.stars != null && !r.isHidden);
    if (validReviews.isEmpty) return 0;
    return validReviews.map((r) => r.stars!).reduce((a, b) => a + b) /
        validReviews.length;
  }

  @override
  void initState() {
    super.initState();

    reviewProvider = context.read<ReviewProvider>();
    employeeAvailabilityProvider = context.read<EmployeeAvailabilityProvider>();

    loadReviews();
    loadAvailability();
  }

  Future<void> loadReviews() async {
    setState(() {
      isLoading = true;
    });

    final response = await reviewProvider.loadData(
      employeeId: widget.employee.user!.userId,
      isHidden: false,
    );

    setState(() {
      reviews = response?.result ?? [];
      isLoading = false;
    });
  }

  Future<void> loadAvailability() async {
    setState(() {
      isLoading = true;
    });

    final response = await employeeAvailabilityProvider.loadData(
      employeeId: widget.employee.user!.userId,
      serviceId: widget.serviceId,
    );

    setState(() {
      availabilities = response?.result ?? [];

      for (var slot in availabilities) {
        final timeRange = "${slot.startTime} – ${slot.endTime}";
        availability[slot.dayOfWeek]?.add(timeRange);
      }

      final filteredAvailability = availability
          .map(
            (day, slots) =>
                MapEntry(day, slots.where((s) => s.isNotEmpty).toList()),
          )
          .map((day, slots) => MapEntry(day, slots))
          .cast<String, List<String>>();

      filteredAvailability.removeWhere((day, slots) => slots.isEmpty);

      availability = filteredAvailability;

      selectedDay = availability.keys.first;

      isLoading = false;
    });
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
          'Employee Details',
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
            _buildEmployeeInfo(colorScheme),
            _buildEmployeeAvailability(colorScheme),
            _buildReviewsTitleSection(colorScheme),
            //_buildAverageRating(colorScheme),
            _buildStatisticsCard(colorScheme),
            _buildReviews(colorScheme),
            // _buildEmployeesTab(colorScheme),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(colorScheme),
    );
  }

  Widget _buildEmployeeInfo(ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.employee.user?.firstName} ${widget.employee.user?.lastName}',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Job title: ${widget.employee.jobTitle}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Qualification',
              style: TextStyle(
                fontSize: 20,
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildQualificationDetailsCard(colorScheme),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Contact',
              style: TextStyle(
                fontSize: 20,
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildContactDetailsCard(colorScheme),
        ],
      ),
    );
  }

  Widget _buildQualificationDetailsCard(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow(
            FontAwesomeIcons.graduationCap,
            'Qualification name',
            widget.employee.qualification?.name ?? 'Not specified',
            null,
            colorScheme,
          ),
          const Divider(height: 24),
          _buildInfoRow(
            FontAwesomeIcons.buildingColumns,
            'Institute name',
            widget.employee.qualification?.instituteName ?? 'Not specified',
            null,
            colorScheme,
          ),
          const Divider(height: 24),
          if (widget.employee.qualification != null &&
              widget.employee.qualification?.procurementYear != null)
            _buildInfoRow(
              FontAwesomeIcons.calendar,
              'Procurement year',
              DateFormat(
                'yyyy',
              ).format(widget.employee.qualification!.procurementYear),
              null,
              colorScheme,
            ),
        ],
      ),
    );
  }

  Widget _buildContactDetailsCard(colorScheme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          if (widget.employee.user != null &&
              widget.employee.user?.phoneNumber != null)
            _buildInfoRow(
              FontAwesomeIcons.phone,
              'Phone number',
              widget.employee.user?.phoneNumber ?? 'Not specified',
              null,
              colorScheme,
            ),
          if (widget.employee.user != null &&
              widget.employee.user?.email != null) ...[
            const Divider(height: 24),
            _buildInfoRow(
              Icons.email,
              'Email',
              widget.employee.user?.email ?? 'Not specified',
              null,
              colorScheme,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String title,
    String value,
    String? subtitle,
    ColorScheme colorScheme,
  ) {
    return Row(
      children: [
        Container(
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
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Map<String, List<String>> availability = {
    "Monday": [],
    "Tuesday": [],
    "Wednesday": [],
    "Thursday": [],
    "Friday": [],
    "Saturday": [],
    "Sunday": [],
  };

  String selectedDay = "Monday";

  Widget _buildEmployeeAvailability(colorScheme) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (availabilities.isEmpty) {
      return SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Availability',
              style: TextStyle(
                fontSize: 20,
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: availability.keys.map((day) {
                final isSelected = selectedDay == day;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(day),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        selectedDay = day;
                      });
                    },
                    selectedColor: colorScheme.primaryContainer,
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 20),
          Text(
            selectedDay,
            style: TextStyle(fontSize: 16, color: colorScheme.onSurface),
          ),
          const Divider(),

          availability[selectedDay]!.isEmpty
              ? Center(
                  child: Text(
                    "No availability",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true, // important
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: availability[selectedDay]!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.access_time,
                          color: colorScheme.primary,
                        ),
                        title: Text(availability[selectedDay]![index]),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildReviewsTitleSection(colorScheme) {
    return Center(
      child: Text(
        'Reviews',
        style: TextStyle(
          fontSize: 20,
          color: colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildReviews(colorScheme) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (reviews.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 50),
        child: const Center(
          child: Text(
            "This employee does not have any reviews.",
            style: TextStyle(color: Colors.grey, fontSize: 15),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: reviews.map((review) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                              Expanded(
                                child: Text(
                                  review.title,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.mauveGray,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "${review.stars}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Container(
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                'Written by: ${review.user.firstName} ${review.user.lastName}',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  review.content,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    height: 1.4,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Last edited: ${DateFormat('dd. MM. yyyy.').format(review.modifiedDate)}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStatisticsCard(ColorScheme colorScheme) {
    if (reviews.isEmpty) {
      return SizedBox.shrink();
    }
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
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
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      _averageRating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.star_rounded,
                      color: Colors.amber,
                      size: 32,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  reviews.length == 1
                      ? '${reviews.length} review'
                      : '${reviews.length} reviews',
                  style: TextStyle(fontSize: 14, color: AppColors.white),
                ),
              ],
            ),
          ),
          _buildStarDistribution(colorScheme),
        ],
      ),
    );
  }

  Widget _buildStarDistribution(ColorScheme colorScheme) {
    final distribution = List.generate(5, (index) {
      final starCount = index + 1;
      return reviews.where((r) => r.stars == starCount && !r.isHidden).length;
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(5, (index) {
        final starNumber = 5 - index;
        final count = distribution[starNumber - 1];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$starNumber',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.star, size: 12, color: Colors.amber[300]),
              const SizedBox(width: 8),
              Container(
                width: 60,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.white30,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: reviews.isEmpty ? 0 : count / reviews.length,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.amber[300],
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 20,
                child: Text(
                  '$count',
                  style: TextStyle(fontSize: 11, color: AppColors.white),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // Widget _buildAverageRating(colorScheme) {
  //   final total = reviews.fold<int>(
  //     0,
  //     (sum, review) => sum + (review.stars ?? 0),
  //   );

  //   final rating = reviews.isEmpty ? 0.0 : total / reviews.length;

  //   return Padding(
  //     padding: const EdgeInsets.only(top: 2),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         RatingBarIndicator(
  //           rating: rating,
  //           itemBuilder: (context, index) =>
  //               const Icon(Icons.star, color: Colors.amber),
  //           itemCount: 5,
  //           itemSize: 10.0,
  //           unratedColor: colorScheme.onSurface,
  //           direction: Axis.horizontal,
  //         ),
  //         SizedBox(width: 4),
  //         Text(rating.toString(), style: TextStyle(fontSize: 13)),
  //         SizedBox(width: 4),
  //         Text("(${reviews.length.toString()} reviews)"),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildBottomBar(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: colorScheme.surfaceContainerLowest),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: _scheduleBookAppointment,
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primaryContainer,
            foregroundColor: colorScheme.onSurface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.calendar_today, size: 20),
              const SizedBox(width: 8),
              Text(
                'Schedule Appointment',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _scheduleBookAppointment() {
    //todo
  }
}
