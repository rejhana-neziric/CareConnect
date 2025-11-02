// Dialog for adding new slots
import 'package:careconnect_admin/models/responses/service.dart';
import 'package:careconnect_admin/models/time_slot.dart';
import 'package:flutter/material.dart';

class AddSlotDialog extends StatefulWidget {
  final String day;
  final Function(TimeSlot) onSlotAdded;
  final List<Service> availableServices;

  const AddSlotDialog({
    super.key,
    required this.day,
    required this.onSlotAdded,
    required this.availableServices,
  });

  @override
  State<AddSlotDialog> createState() => _AddSlotDialogState();
}

class _AddSlotDialogState extends State<AddSlotDialog> {
  late TimeOfDay startTime;
  late TimeOfDay endTime;
  Service? selectedService;

  @override
  void initState() {
    super.initState();
    startTime = const TimeOfDay(hour: 9, minute: 0);
    endTime = const TimeOfDay(hour: 17, minute: 0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      title: Text('Add Availability for ${widget.day}'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Time selection
            Row(
              children: [
                Flexible(
                  child: ListTile(
                    title: const Text('Start Time'),
                    subtitle: Text(startTime.format(context)),
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
                                hourMinuteTextColor: colorScheme.onSurface,
                                hourMinuteColor: MaterialStateColor.resolveWith(
                                  (states) =>
                                      states.contains(MaterialState.selected)
                                      ? colorScheme.primary
                                      : colorScheme.surfaceContainerLow,
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
                                hourMinuteTextColor: colorScheme.onSurface,
                                hourMinuteColor: MaterialStateColor.resolveWith(
                                  (states) =>
                                      states.contains(MaterialState.selected)
                                      ? colorScheme.primary
                                      : colorScheme.surfaceContainerLow,
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
                    value: selectedService == service,
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
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final slot = TimeSlot(
              day: widget.day,
              start: startTime,
              end: endTime,
              service: selectedService,
            );
            widget.onSlotAdded(slot);
            Navigator.pop(context);
          },
          child: const Text('Add Slot'),
        ),
      ],
    );
  }
}
