import 'package:careconnect_mobile/core/layouts/master_screen.dart';
import 'package:careconnect_mobile/models/responses/attendance_status.dart';
import 'package:careconnect_mobile/models/responses/employee.dart';
import 'package:careconnect_mobile/models/responses/search_result.dart';
import 'package:careconnect_mobile/providers/attendance_status_provider.dart';
import 'package:careconnect_mobile/providers/employee_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

class EmployeeDetailsScreen extends StatefulWidget {
  Employee? employee;

  EmployeeDetailsScreen({super.key, this.employee});

  @override
  State<EmployeeDetailsScreen> createState() => _EmployeeDetailsScreenState();
}

// flutter form builder

class _EmployeeDetailsScreenState extends State<EmployeeDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};

  late AttendanceStatusProvider attendanceStatusProvider;
  late EmployeeProvider employeeProvider;
  SearchResult<AttendanceStatus>? attendaceStatusResult;
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    attendanceStatusProvider = context.read<AttendanceStatusProvider>();
    employeeProvider = context.read<EmployeeProvider>();

    _initialValue = {
      "hireDate": widget.employee?.hireDate.toString(),
      "jobTitle": widget.employee?.jobTitle,
    };

    print(_initialValue);

    initForm();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      "Employee Details",
      Column(children: [isLoading ? Container() : _buildForm(), _saveRow()]),
    );
  }

  Future initForm() async {
    attendaceStatusResult = await attendanceStatusProvider.get();
    print("IDDD ${attendaceStatusResult?.result[0].attendanceStatusId}");
    setState(() {
      isLoading = false;
    });
  }

  Widget _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: FormBuilderTextField(
                    decoration: InputDecoration(labelText: "Hire data"),
                    name: "hireDate",
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: FormBuilderTextField(
                    decoration: InputDecoration(labelText: "Job title"),

                    name: "jobTitle",
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: FormBuilderDropdown(
                    name: "AttendanceSatausID",
                    decoration: InputDecoration(labelText: "Attendance Status"),
                    items:
                        attendaceStatusResult?.result
                            .map(
                              (item) => DropdownMenuItem(
                                value: item.attendanceStatusId.toString(),
                                child: Text(item.name ?? ""),
                              ),
                            )
                            .toList() ??
                        [],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _saveRow() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () {
              _formKey.currentState?.saveAndValidate();
              debugPrint(_formKey.currentState?.value.toString());

              if (widget.employee == null) {
                // INSERT test
                employeeProvider.insert(_formKey.currentState?.value);
              } else {
                employeeProvider.update(1, _formKey.currentState?.value);
              }
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }
}
