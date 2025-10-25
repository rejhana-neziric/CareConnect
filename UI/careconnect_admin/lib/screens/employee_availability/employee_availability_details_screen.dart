import 'package:careconnect_admin/core/layouts/master_screen.dart';
import 'package:careconnect_admin/core/theme/app_colors.dart';
import 'package:careconnect_admin/models/responses/employee.dart';
import 'package:careconnect_admin/models/time_slot.dart';
import 'package:careconnect_admin/providers/employee_provider.dart';
import 'package:careconnect_admin/screens/employee_availability/widgets/employee_availability_picker.dart';
import 'package:careconnect_admin/widgets/confirm_dialog.dart';
import 'package:careconnect_admin/widgets/custom_dropdown_field.dart';
import 'package:careconnect_admin/widgets/primary_button.dart';
import 'package:careconnect_admin/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class EmployeeAvailabilityDetailsScreen extends StatefulWidget {
  const EmployeeAvailabilityDetailsScreen({super.key});

  @override
  State<EmployeeAvailabilityDetailsScreen> createState() =>
      _EmployeeAvailabilityDetailsScreenState();
}

class _EmployeeAvailabilityDetailsScreenState
    extends State<EmployeeAvailabilityDetailsScreen> {
  late EmployeeProvider employeeProvider;

  List<Employee> employees = [];
  Map<String, String?> employeesOption = {};

  Map<int, TimeSlot> originalSlots = {};
  Map<int, TimeSlot> currentSlots = {};

  int? selectedEmployeeId;

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    employeeProvider = context.read<EmployeeProvider>();
    loadEmployees();

    super.initState();
  }

  Future<void> loadEmployees() async {
    final response = await employeeProvider.loadData(
      employed: true,
      retrieveAll: true,
    );

    setState(() {
      employees = response?.result ?? [];
    });
  }

  Future<void> loadAvailability(int employeeId) async {
    final response = await employeeProvider.getEmployeeAvailability(employeeId);

    currentSlots = {};
    originalSlots = {};

    // for (var el in response.employeeAvailabilities) {
    //   currentSlots[el.employeeAvailabilityId] = el.toTimeSlot();
    //   originalSlots[el.employeeAvailabilityId] = el.toTimeSlot();
    // }

    for (var el in response) {
      currentSlots[el.employeeAvailabilityId] = el.toTimeSlot();
      originalSlots[el.employeeAvailabilityId] = el.toTimeSlot();
    }

    _formKey.currentState?.patchValue({'availability': currentSlots});
  }

  List<DropdownMenuItem<int>> buildEmployeesList(List<Employee> employees) {
    return employees.map((employee) {
      return DropdownMenuItem<int>(
        value: employee.user?.userId,
        child: Text("${employee.user?.firstName} ${employee.user?.lastName}"),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final colorScheme = theme.colorScheme;

    return MasterScreen(
      "Employee Availability",
      currentScreen: "Employee Availability",
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              // Employee selection section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person),
                          const SizedBox(width: 4),
                          Text(
                            'Employee Information',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(width: 16),
                          CustomDropdownField(
                            width: 400,
                            name: "employee",
                            label: "Employee Name",
                            items: buildEmployeesList(employees),
                            onChanged: (value) async {
                              if (value == null) return;
                              setState(() => selectedEmployeeId = value);
                              await loadAvailability(value);
                            },
                          ),
                          //  ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Employee Availability picker
              Expanded(
                child: EmployeeAvailabilityPicker(
                  name: 'availability',
                  // validator: (slots) {
                  //   if (slots == null || slots.isEmpty) {
                  //     return 'Please add at least one availability slot';
                  //   }

                  //   for (int i = 0; i < slots.length; i++) {
                  //     for (int j = i + 1; j < slots.length; j++) {
                  //       if (slots.values.toList()[i].day ==
                  //           slots.values.toList()[j].day) {
                  //         if (_slotsOverlap(
                  //           slots.values.toList()[i],
                  //           slots.values.toList()[j],
                  //         )) {
                  //           return 'Overlapping time slots found for ${slots.values.toList()[i].day}';
                  //         }
                  //       }
                  //     }
                  //   }

                  //   return null;
                  // },
                ),
              ),

              const SizedBox(height: 20),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Tooltip(
                    message: 'Revert to last saved values.',
                    child: TextButton(
                      onPressed: () async {
                        if (selectedEmployeeId != null) {
                          await loadAvailability(selectedEmployeeId!);
                        }
                      },
                      child: const Text('Reset'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  PrimaryButton(
                    onPressed: () => _saveAvailability(),
                    label: 'Save Availability',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _slotsOverlap(TimeSlot slot1, TimeSlot slot2) {
    final start1 = slot1.start.hour * 60 + slot1.start.minute;
    final end1 = slot1.end.hour * 60 + slot1.end.minute;
    final start2 = slot2.start.hour * 60 + slot2.start.minute;
    final end2 = slot2.end.hour * 60 + slot2.end.minute;

    return start1 < end2 && start2 < end1;
  }

  void _saveAvailability() async {
    final formState = _formKey.currentState;
    if (formState == null) return;

    if (formState.saveAndValidate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        final values = formState.value;
        final employeeId = selectedEmployeeId;

        final slots = values['availability'] as Map<int, TimeSlot>;

        if (employeeId == null) {
          Navigator.pop(context);

          CustomSnackbar.show(
            context,
            message: 'Please choose employee name.',
            type: SnackbarType.error,
          );
          return;
        }
        print(slots);

        if (slots.values.toList().isEmpty == true) {
          Navigator.pop(context);

          CustomSnackbar.show(
            context,
            message: 'Please add at least one availability slot',
            type: SnackbarType.error,
          );
          return;
        }

        for (int i = 0; i < slots.length; i++) {
          for (int j = i + 1; j < slots.length; j++) {
            if (slots.values.toList()[i].day == slots.values.toList()[j].day) {
              if (_slotsOverlap(
                slots.values.toList()[i],
                slots.values.toList()[j],
              )) {
                Navigator.pop(context);

                CustomSnackbar.show(
                  context,
                  message:
                      'Overlapping time slots found for ${slots.values.toList()[i].day}',
                  type: SnackbarType.error,
                );
                return;
              }
            }
          }
        }

        final shouldProceed = await CustomConfirmDialog.show(
          context,
          icon: Icons.info,
          iconBackgroundColor: AppColors.mauveGray,
          title: 'Update Availability',
          content:
              'Are you sure you want to save availability for this employee?',
          confirmText: 'Save',
          cancelText: 'Cancel',
        );

        Navigator.pop(context);

        if (shouldProceed != true) return;

        if (originalSlots.isEmpty == true) {
          // call API for insert of all current slots
          await employeeProvider.createEmployeeAvailability(
            employeeId,
            currentSlots.values.toList(),
          );
        } else {
          //compare original and current and call API for update
          await employeeProvider.updateEmployeeAvailability(
            employeeId: employeeId,
            currentSlots: slots,
            originalSlots: originalSlots,
          );
        }

        if (!mounted) return;

        Navigator.pop(context);

        CustomSnackbar.show(
          context,
          message: 'Availability saved successfully!',
          type: SnackbarType.success,
        );
      } catch (error) {
        Navigator.pop(context);

        CustomSnackbar.show(
          context,
          message: 'Failed to save availability! Please try again.',
          type: SnackbarType.error,
        );
      }
    } else {
      CustomSnackbar.show(
        context,
        message: 'Please fix the errors above',
        type: SnackbarType.error,
      );
    }
  }
}
