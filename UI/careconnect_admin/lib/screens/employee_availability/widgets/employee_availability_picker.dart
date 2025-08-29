import 'package:careconnect_admin/models/time_slot.dart';
import 'package:careconnect_admin/screens/employee_availability/widgets/availability_widget.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class EmployeeAvailabilityPicker extends FormBuilderField<Map<int, TimeSlot>> {
  EmployeeAvailabilityPicker({
    super.key,
    required super.name,
    Map<int, TimeSlot>? initialValue,
    super.validator,
  }) : super(
         initialValue: initialValue ?? {},
         builder: (field) {
           return AvailabilityWidget(field: field);
         },
       );
}
