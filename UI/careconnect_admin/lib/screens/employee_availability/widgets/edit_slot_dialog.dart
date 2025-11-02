import 'package:careconnect_admin/models/responses/service.dart';
import 'package:careconnect_admin/models/time_slot.dart';
import 'package:flutter/material.dart';

class EditSlotDialog extends StatefulWidget {
  final TimeSlot slot;
  final Function(TimeSlot) onSlotUpdated;
  final VoidCallback onSlotDeleted;
  final List<Service> availableServices;

  const EditSlotDialog({
    super.key,
    required this.slot,
    required this.onSlotUpdated,
    required this.onSlotDeleted,
    required this.availableServices,
  });

  @override
  State<EditSlotDialog> createState() => _EditSlotDialogState();
}

class _EditSlotDialogState extends State<EditSlotDialog> {
  late TimeOfDay startTime;
  late TimeOfDay endTime;
  late Service? selectedService;

  @override
  void initState() {
    super.initState();
    startTime = widget.slot.start;
    endTime = widget.slot.end;
    selectedService = widget.slot.service;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      title: Text('Edit ${widget.slot.day} Availability'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Time selection with resize handles
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: ListTile(
                            title: const Text('Start Time'),
                            subtitle: Text(startTime.format(context)),
                            leading: const Icon(Icons.schedule),
                            onTap: () async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: startTime,
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      timePickerTheme: TimePickerThemeData(
                                        backgroundColor:
                                            colorScheme.surfaceContainerLowest,
                                        dialHandColor: colorScheme.primary,
                                        dialBackgroundColor:
                                            colorScheme.surfaceContainerLow,
                                        hourMinuteTextColor:
                                            colorScheme.onSurface,
                                        hourMinuteColor:
                                            MaterialStateColor.resolveWith(
                                              (states) =>
                                                  states.contains(
                                                    MaterialState.selected,
                                                  )
                                                  ? colorScheme.primary
                                                  : colorScheme
                                                        .surfaceContainerLow,
                                            ),
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (time != null) {
                                setState(() => startTime = time);
                              }
                            },
                          ),
                        ),
                        Flexible(
                          child: ListTile(
                            title: const Text('End Time'),
                            subtitle: Text(endTime.format(context)),
                            leading: const Icon(Icons.schedule_outlined),
                            onTap: () async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: endTime,
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      timePickerTheme: TimePickerThemeData(
                                        backgroundColor:
                                            colorScheme.surfaceContainerLowest,
                                        dialHandColor: colorScheme.primary,
                                        dialBackgroundColor:
                                            colorScheme.surfaceContainerLow,
                                        hourMinuteTextColor:
                                            colorScheme.onSurface,
                                        hourMinuteColor:
                                            MaterialStateColor.resolveWith(
                                              (states) =>
                                                  states.contains(
                                                    MaterialState.selected,
                                                  )
                                                  ? colorScheme.primary
                                                  : colorScheme
                                                        .surfaceContainerLow,
                                            ),
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (time != null) {
                                setState(() => endTime = time);
                              }
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Quick time adjustment buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              startTime = TimeOfDay(
                                hour: (startTime.hour - 1).clamp(0, 23),
                                minute: startTime.minute,
                              );
                            });
                          },
                          icon: const Icon(Icons.remove),
                          label: const Text('Start -1h'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              endTime = TimeOfDay(
                                hour: (endTime.hour + 1).clamp(0, 23),
                                minute: endTime.minute,
                              );
                            });
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('End +1h'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Services selection
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Available Services:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),

            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: widget.availableServices.length,
                itemBuilder: (context, index) {
                  final service = widget.availableServices[index];
                  return CheckboxListTile(
                    title: Text(service.name),
                    value: selectedService?.serviceId == service.serviceId,
                    onChanged: (checked) {
                      setState(() {
                        if (checked == true) {
                          selectedService = service;
                        }
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton.icon(
          onPressed: () {
            widget.onSlotDeleted();
            Navigator.pop(context);
          },
          icon: const Icon(Icons.delete, color: Colors.red),
          label: const Text('Delete', style: TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final updatedSlot = widget.slot.copyWith(
              start: startTime,
              end: endTime,
              service: selectedService,
            );
            widget.onSlotUpdated(updatedSlot);
            Navigator.pop(context);
          },
          child: const Text('Update'),
        ),
      ],
    );
  }
}
