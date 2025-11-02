import 'package:careconnect_admin/models/responses/service.dart';
import 'package:careconnect_admin/models/time_slot.dart';
import 'package:careconnect_admin/providers/permission_provider.dart';
import 'package:careconnect_admin/providers/service_provider.dart';
import 'package:careconnect_admin/screens/employee_availability/widgets/add_slot_dialog.dart';
import 'package:careconnect_admin/screens/employee_availability/widgets/edit_slot_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class AvailabilityWidget extends StatefulWidget {
  final FormFieldState<Map<int, TimeSlot>> field;

  const AvailabilityWidget({super.key, required this.field});

  @override
  State<AvailabilityWidget> createState() => _AvailabilityWidgetState();
}

class _AvailabilityWidgetState extends State<AvailabilityWidget> {
  late PermissionProvider permissionProvider;

  final List<String> daysOfWeek = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  Map<int, TimeSlot> get slots => widget.field.value ?? const {};
  TimeSlot? selectedSlot;
  int? selectedSlotId;
  bool showWeekView = true;

  late ServiceProvider serviceProvider;
  List<Service> services = [];

  @override
  void initState() {
    super.initState();

    serviceProvider = context.read<ServiceProvider>();

    permissionProvider = Provider.of<PermissionProvider>(
      context,
      listen: false,
    );

    loadServices();
  }

  void updateField() {
    widget.field.didChange(slots);
  }

  Future<void> loadServices() async {
    final response = await serviceProvider.get();

    setState(() {
      services = response.result;
    });
  }

  int _tempIdCounter = -1;

  void addSlot(String day) {
    showDialog(
      context: context,
      builder: (context) => AddSlotDialog(
        day: day,
        onSlotAdded: (slot) {
          _tempIdCounter--;

          final updated = Map<int, TimeSlot>.from(slots);
          updated[_tempIdCounter] = slot;

          widget.field.didChange(updated);
          setState(() {});
        },
        availableServices: services,
      ),
    );
  }

  void editSlot(TimeSlot slot) {
    showDialog(
      context: context,
      builder: (context) => EditSlotDialog(
        slot: slot,
        onSlotUpdated: (updatedSlot) {
          final updatedSlots = Map<int, TimeSlot>.from(slots);

          final key = updatedSlots.entries
              .firstWhere((entry) => entry.value == slot)
              .key;

          updatedSlots[key] = updatedSlot;

          widget.field.didChange(updatedSlots);
          setState(() {});
        },
        onSlotDeleted: () {
          final updated = Map<int, TimeSlot>.from(slots);

          updated.removeWhere((key, value) => value == slot);

          widget.field.didChange(updated);

          setState(() {});
        },
        availableServices: services,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final formSlots = FormBuilder.of(context)?.instantValue['availability'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Weekly Availability', style: theme.textTheme.headlineSmall),
            Row(
              children: [
                IconButton(
                  icon: Icon(showWeekView ? Icons.view_list : Icons.view_week),
                  onPressed: () {
                    setState(() {
                      showWeekView = !showWeekView;
                    });
                  },
                  tooltip: showWeekView ? 'List View' : 'Week View',
                ),
                Text('${formSlots?.length ?? 0} slots'),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Error message
        if (widget.field.hasError)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              widget.field.errorText!,
              style: TextStyle(color: theme.colorScheme.onErrorContainer),
            ),
          ),

        // Content based on view mode
        Expanded(
          child: showWeekView ? _buildWeekView(colorScheme) : _buildListView(),
        ),
      ],
    );
  }

  Widget _buildWeekView(ColorScheme colorScheme) {
    return Card(
      child: Column(
        children: [
          // Days header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const SizedBox(width: 60),
                ...daysOfWeek
                    .take(7)
                    .map(
                      (day) => Expanded(
                        child: Center(
                          child: Text(
                            day.substring(0, 3),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
              ],
            ),
          ),
          const Divider(),

          // Time grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: SizedBox(
                  height: 605,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Time labels
                      SizedBox(
                        width: 60,
                        child: Column(
                          children: List.generate(12, (i) {
                            final hour = 8 + i;
                            return SizedBox(
                              height: 50,
                              child: Text(
                                '$hour:00',
                                style: const TextStyle(fontSize: 11),
                              ),
                            );
                          }),
                        ),
                      ),

                      // Day columns
                      ...daysOfWeek
                          .take(7)
                          .map(
                            (day) => Expanded(
                              child: _buildDayColumn(day, colorScheme),
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayColumn(String day, ColorScheme colorScheme) {
    final daySlots = slots.values.where((s) => s.day == day).toList();

    return GestureDetector(
      onTap: () => addSlot(day),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Stack(
          children: [
            // Background grid
            Column(
              children: List.generate(
                12,
                (i) => SizedBox(
                  height: 50,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Slots
            ...daySlots.map((slot) => _buildSlotBlock(slot, colorScheme)),

            // Add button (when empty or on hover)
            if (daySlots.isEmpty &&
                permissionProvider.canInsertEmployeeAvailability())
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle_outline, color: Colors.grey.shade400),
                    const SizedBox(height: 4),
                    Text(
                      'Add Slot',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlotBlock(TimeSlot slot, ColorScheme colorScheme) {
    final startMinutes = slot.start.hour * 60 + slot.start.minute;
    final endMinutes = slot.end.hour * 60 + slot.end.minute;
    final top = ((startMinutes - 480) / 60) * 50; // 480 = 8 * 60 (8 AM)
    final height = ((endMinutes - startMinutes) / 60) * 50;

    return Positioned(
      top: top,
      left: 2,
      right: 2,
      height: height,
      child: GestureDetector(
        onTap: () => permissionProvider.canUpdateEmployeeAvailability()
            ? editSlot(slot)
            : null,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 1),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHigh,
            border: Border.all(color: colorScheme.surfaceContainerHigh),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${slot.start.format(context)} - ${slot.end.format(context)}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 2),
                Flexible(
                  child: Text(
                    slot.service?.name ?? "",
                    //slot.services.join(', '),
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListView() {
    final groupedSlots = <String, List<TimeSlot>>{};

    for (final slot in slots.values) {
      groupedSlots.putIfAbsent(slot.day, () => []).add(slot);
    }

    return ListView(
      children: daysOfWeek.map((day) {
        final daySlots = groupedSlots[day] ?? [];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ExpansionTile(
            title: Row(
              children: [
                Text(day, style: const TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                Chip(
                  label: Text('${daySlots.length}'),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ],
            ),
            children: [
              ...daySlots.map(
                (slot) => ListTile(
                  leading: const Icon(Icons.schedule),
                  title: Text(
                    '${slot.start.format(context)} - ${slot.end.format(context)}',
                  ),
                  subtitle: Text(slot.service?.name ?? ""),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => editSlot(slot),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          final updated = Map<int, TimeSlot>.from(slots);

                          updated.removeWhere((key, value) => value == slot);

                          widget.field.didChange(updated);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  onTap: () => editSlot(slot),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.add),
                title: Text('Add new slot for $day'),
                onTap: () => addSlot(day),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
