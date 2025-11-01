import 'package:careconnect_mobile/models/responses/employee.dart';
import 'package:careconnect_mobile/models/responses/employee_availability.dart';
import 'package:careconnect_mobile/models/responses/service.dart';
import 'package:careconnect_mobile/models/time_slot.dart';
import 'package:careconnect_mobile/providers/employee_provider.dart';
import 'package:careconnect_mobile/screens/appointments/scheduling_appointment/appointment_confirmation_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentSchedulingScreen extends StatefulWidget {
  final int clientId;
  final int childId;
  final Employee employee;
  final Service service;
  final bool isRescheduling;
  final int? appointmentId;

  const AppointmentSchedulingScreen({
    super.key,
    required this.clientId,
    required this.childId,
    required this.employee,
    required this.service,
    this.isRescheduling = false,
    this.appointmentId,
  });

  @override
  State<AppointmentSchedulingScreen> createState() =>
      _AppointmentSchedulingScreenState();
}

class _AppointmentSchedulingScreenState
    extends State<AppointmentSchedulingScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<EmployeeAvailability> availabilities = [];
  Set<DateTime> availableDays = {};
  bool _isLoading = true;

  List<TimeSlot> timeSlots = [];
  TimeSlot? selectedTimeSlot;

  bool _isLoadingTimeSlots = false;

  late EmployeeProvider employeeProvider;

  @override
  void initState() {
    super.initState();

    employeeProvider = context.read<EmployeeProvider>();

    _loadAvailabilities();
  }

  Future<void> _loadAvailabilities() async {
    setState(() => _isLoading = true);

    if (widget.employee.user == null) return;

    final response = await employeeProvider.getEmployeeAvailability(
      widget.employee.user!.userId,
    );

    availabilities = response
        .where((a) => a.service?.serviceId == widget.service.serviceId)
        .toList();

    _generateAvailableDays();
    setState(() => _isLoading = false);
  }

  void _generateAvailableDays() {
    availableDays.clear();
    DateTime startDate = DateTime.now();
    DateTime endDate = startDate.add(Duration(days: 90));

    for (
      DateTime date = startDate;
      date.isBefore(endDate);
      date = date.add(Duration(days: 1))
    ) {
      String dayName = DateFormat('EEEE').format(date);
      bool hasAvailability = availabilities.any(
        (avail) => avail.dayOfWeek.toLowerCase() == dayName.toLowerCase(),
      );

      if (hasAvailability &&
          date.isAfter(DateTime.now().subtract(Duration(days: 1)))) {
        availableDays.add(DateTime(date.year, date.month, date.day));
      }
    }
  }

  Future<void> _generateTimeSlots(DateTime selectedDate) async {
    setState(() => _isLoadingTimeSlots = true);

    await Future.delayed(const Duration(milliseconds: 300));

    timeSlots.clear();
    selectedTimeSlot = null;

    final dailyAvailabilities = await employeeProvider.getEmployeeAvailability(
      widget.employee.user!.userId,
      date: selectedDate,
    );

    for (var avail in dailyAvailabilities) {
      final startParts = avail.startTime.split(':');
      final endParts = avail.endTime.split(':');

      final startDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        int.parse(startParts[0]),
        int.parse(startParts[1]),
      );

      final endDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        int.parse(endParts[0]),
        int.parse(endParts[1]),
      );
      final timeRange =
          "${DateFormat('HH:mm').format(startDateTime)} - ${DateFormat('HH:mm').format(endDateTime)}";

      final isAvailable = !(avail.isBooked);

      timeSlots.add(
        TimeSlot(
          time: TimeOfDay.fromDateTime(startDateTime),
          isAvailable: isAvailable,
          displayTime: timeRange,
          availability: avail,
        ),
      );
    }

    setState(() => _isLoadingTimeSlots = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLow,
      appBar: AppBar(
        title: Text(
          'Schedule Appointment',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        backgroundColor: colorScheme.surfaceContainerLow,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Loading available dates...',
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                _buildCalendar(colorScheme),
                if (_selectedDay != null) ...[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSelectedDayInfo(colorScheme),
                          SizedBox(height: 16),
                          Expanded(
                            child: _isLoading
                                ? Center(child: CircularProgressIndicator())
                                : Column(
                                    children: [
                                      // Time Slots Header
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              'Available Times',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: colorScheme.onSurface,
                                              ),
                                            ),
                                            Spacer(),
                                            Icon(
                                              Icons.access_time,
                                              color: Colors.grey[500],
                                              size: 16,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              '30 min slots',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(height: 12),

                                      // Time Slots Grid
                                      Expanded(
                                        child: _buildTimeSlotGrid(colorScheme),
                                      ),

                                      if (selectedTimeSlot != null)
                                        Container(
                                          width: double.infinity,
                                          margin: EdgeInsets.all(16),
                                          child: ElevatedButton(
                                            onPressed: _navigateToConfirmation,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  colorScheme.primary,
                                              padding: EdgeInsets.symmetric(
                                                vertical: 16,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              elevation: 2,
                                            ),
                                            child: Text(
                                              'Continue to Review',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  Expanded(child: _buildSelectDate(colorScheme)),
                ],
              ],
            ),
    );
  }

  Widget _buildCalendar(ColorScheme colorScheme) {
    return Container(
      margin: EdgeInsets.all(16),
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
      child: TableCalendar<DateTime>(
        firstDay: DateTime.now(),
        lastDay: DateTime.now().add(Duration(days: 90)),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        availableGestures: AvailableGestures.all,
        onDaySelected: (selectedDay, focusedDay) {
          if (availableDays.contains(
            DateTime(selectedDay.year, selectedDay.month, selectedDay.day),
          )) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
              _generateTimeSlots(_selectedDay!);
            });
          }
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        enabledDayPredicate: (day) {
          return availableDays.contains(DateTime(day.year, day.month, day.day));
        },
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          defaultTextStyle: TextStyle(color: colorScheme.onSurface),
          weekendTextStyle: TextStyle(color: colorScheme.onSurface),
          holidayTextStyle: TextStyle(color: Colors.grey[600]),
          disabledTextStyle: TextStyle(color: Colors.grey[600]),
          selectedDecoration: BoxDecoration(
            color: colorScheme.primary,
            shape: BoxShape.circle,
          ),
          todayTextStyle: TextStyle(color: colorScheme.onSurface),
          todayDecoration: BoxDecoration(
            border: Border.all(color: colorScheme.primary, width: 2),
            shape: BoxShape.circle,
          ),
          defaultDecoration: BoxDecoration(shape: BoxShape.circle),
          weekendDecoration: BoxDecoration(shape: BoxShape.circle),
          markerDecoration: BoxDecoration(
            color: Color(0xFF4CAF50),
            shape: BoxShape.circle,
          ),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: true,
          titleCentered: true,
          formatButtonShowsNext: false,
          formatButtonDecoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          formatButtonTextStyle: TextStyle(color: Colors.white),
          leftChevronIcon: Icon(Icons.chevron_left, color: colorScheme.primary),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            color: colorScheme.primary,
          ),
        ),
        eventLoader: (day) {
          if (availableDays.contains(DateTime(day.year, day.month, day.day))) {
            return [day];
          }
          return [];
        },
      ),
    );
  }

  Widget _buildSelectedDayInfo(ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.calendar_today, color: colorScheme.primary),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selected Date',
                style: TextStyle(fontSize: 14, color: colorScheme.primary),
              ),
              Text(
                DateFormat('EEEE, d MMMM, y').format(_selectedDay!),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlotGrid(ColorScheme colorScheme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2.5,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: timeSlots.length,
        itemBuilder: (context, index) {
          final timeSlot = timeSlots[index];
          final isSelected = selectedTimeSlot == timeSlot;

          return GestureDetector(
            onTap: timeSlot.isAvailable
                ? () {
                    setState(() {
                      selectedTimeSlot = timeSlot;
                    });
                  }
                : null,
            child: Container(
              decoration: BoxDecoration(
                color: !timeSlot.isAvailable
                    ? colorScheme.surfaceContainerLowest
                    : isSelected
                    ? colorScheme.primary
                    : colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: !timeSlot.isAvailable
                      ? colorScheme.surfaceContainerLowest
                      : isSelected
                      ? colorScheme.primary
                      : colorScheme.surfaceContainerLowest,
                  width: 1,
                ),
                boxShadow: timeSlot.isAvailable
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      timeSlot.displayTime,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: !timeSlot.isAvailable
                            ? Colors.grey[400]
                            : isSelected
                            ? colorScheme.onSurface
                            : colorScheme.onSurface,
                      ),
                    ),
                    if (!timeSlot.isAvailable)
                      Text(
                        'Booked',
                        style: TextStyle(fontSize: 10, color: Colors.grey[400]),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _navigateToConfirmation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppointmentConfirmationScreen(
          selectedDate: _selectedDay ?? DateTime.now(),
          selectedTime: selectedTimeSlot!,
          selectedEmployee: widget.employee,
          availability: selectedTimeSlot!.availability,
          clientId: widget.clientId,
          childId: widget.childId,
          isRescheduling: widget.isRescheduling,
          appointmentId: widget.appointmentId,
        ),
      ),
    );
  }

  Widget _buildSelectDate(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today, size: 64, color: colorScheme.onSurface),
          SizedBox(height: 16),
          Text(
            'Select a date to view',
            style: TextStyle(fontSize: 18, color: colorScheme.onSurface),
          ),
          Text(
            'available time slots',
            style: TextStyle(fontSize: 18, color: colorScheme.onSurface),
          ),
        ],
      ),
    );
  }
}
