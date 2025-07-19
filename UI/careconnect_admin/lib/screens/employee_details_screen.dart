import 'package:careconnect_admin/layouts/master_screen.dart';
import 'package:careconnect_admin/models/attendance_status.dart';
import 'package:careconnect_admin/models/employee.dart';
import 'package:careconnect_admin/models/search_objects/employee_additional_data.dart';
import 'package:careconnect_admin/models/search_objects/employee_search_object.dart';
import 'package:careconnect_admin/models/search_result.dart';
import 'package:careconnect_admin/providers/attendance_status_provider.dart';
import 'package:careconnect_admin/providers/employee_form_provider.dart';
import 'package:careconnect_admin/providers/employee_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EmployeeDetailsScreen extends StatefulWidget {
  final Employee? employee;

  const EmployeeDetailsScreen({super.key, this.employee});

  @override
  State<EmployeeDetailsScreen> createState() => _EmployeeDetailsScreenState();
}

class _EmployeeDetailsScreenState extends State<EmployeeDetailsScreen> {
  Map<String, dynamic> _initialValue = {};
  SearchResult<Employee>? result;
  late AttendanceStatusProvider attendanceStatusProvider;
  late EmployeeProvider employeeProvider;
  late EmployeeFormProvider employeeFormProvider;
  SearchResult<AttendanceStatus>? attendaceStatusResult;
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    employeeProvider = context.read<EmployeeProvider>();
    employeeFormProvider = context.read<EmployeeFormProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initForm();
    });
  }

  // optimize
  Future<SearchResult<Employee>?> loadData({int page = 0}) async {
    SearchResult<Employee>? result;

    final filterObject = EmployeeSearchObject(
      additionalData: EmployeeAdditionalData(
        isUserIncluded: true,
        isQualificationIncluded: true,
      ),
      includeTotalCount: true,
    );

    final filter = filterObject.toJson();

    final newResult = await employeeProvider.get(filter: filter);

    result = newResult;

    if (mounted) {
      setState(() {});
    }

    return result;
  }

  Future<void> initForm() async {
    if (widget.employee == null) {
      employeeFormProvider.setForInsert();
    } else {
      employeeFormProvider.setForUpdate({
        "username": widget.employee?.user.username,
        "firstName": widget.employee?.user.firstName,
        "lastName": widget.employee?.user.lastName,
        "status": widget.employee?.user.status,
        "email": widget.employee?.user.email,
        "phoneNumber": widget.employee?.user.phoneNumber,
        "address": widget.employee?.user.address,
        "hireDate": widget.employee?.hireDate,
        "jobTitle": widget.employee?.jobTitle,
        "qualificationName": widget.employee?.qualification?.name,
        "qualificationInstituteName":
            widget.employee?.qualification?.instituteName,
        "qualificationProcurementYear":
            widget.employee?.qualification?.procurementYear,
        "birthDate": widget.employee?.user.birthDate,
        "gender": widget.employee?.user.gender,
      });
    }

    setState(() {
      _initialValue = Map<String, dynamic>.from(
        employeeFormProvider.initialData,
      );
      isLoading = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (employeeFormProvider.formKey.currentState != null) {
        employeeFormProvider.formKey.currentState!.patchValue(_initialValue);
      }
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      "Employee Details",
      SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (!isLoading) _buildForm(),
                const SizedBox(height: 20),
                _saveRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    final employeeFormProvider = Provider.of<EmployeeFormProvider>(context);

    return FormBuilder(
      key: employeeFormProvider.formKey,
      autovalidateMode: AutovalidateMode.disabled,
      initialValue: _initialValue,
      onChanged: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_buildSectionTitle("Personal Information")],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customTextField(
                    width: 400,
                    name: 'firstName',
                    label: 'First Name',
                    validator: employeeFormProvider.validateName,
                    enabled: !employeeFormProvider.isUpdate,
                  ),
                  customDateField(
                    width: 400,
                    name: 'birthDate',
                    label: 'Birth Date',
                    enabled: !employeeFormProvider.isUpdate,
                  ),
                  customTextField(
                    width: 400,
                    name: 'address',
                    label: 'Address',
                    validator: employeeFormProvider.validateAddress,
                  ),
                  customTextField(
                    width: 400,
                    name: 'email',
                    label: 'Email',
                    validator: employeeFormProvider.validateEmail,
                  ),
                  customTextField(
                    width: 400,
                    name: 'username',
                    label: 'Username',
                    validator: employeeFormProvider.validateUsername,
                  ),
                ],
              ),
              const SizedBox(width: 60),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customTextField(
                    width: 400,
                    name: 'lastName',
                    label: 'Last Name',
                    validator: employeeFormProvider.validateName,
                    enabled: !employeeFormProvider.isUpdate,
                  ),
                  customDropdownField<String>(
                    width: 400,
                    name: 'gender',
                    label: 'Gender',
                    items: [
                      DropdownMenuItem(value: 'M', child: Text('Male')),
                      DropdownMenuItem(value: 'F', child: Text('Female')),
                    ],
                    validator: employeeFormProvider.validateNonEmpty,
                    enabled: !employeeFormProvider.isUpdate,
                  ),
                  customTextField(
                    width: 400,
                    name: 'phoneNumber',
                    hintText: '61234567',
                    prefixText: '+387 ',
                    label: 'Phone Number',
                    validator: employeeFormProvider.validatePhoneNumber,
                  ),
                  customTextField(
                    width: 400,
                    name: 'password',
                    label: 'Password',
                    validator: (value) =>
                        employeeFormProvider.validatePassword(value),
                  ),
                  customTextField(
                    width: 400,
                    name: 'confirmationPassword',
                    label: 'Confirmation Password',
                    validator: (value) {
                      final password = employeeFormProvider
                          .formKey
                          .currentState
                          ?.fields['password']
                          ?.value;

                      return employeeFormProvider.validateConfirmationPassword(
                        value,
                        password,
                      );
                    },
                    enabled: !employeeFormProvider.isUpdate,
                  ),
                  if (employeeFormProvider.isUpdate)
                    customDropdownField<bool>(
                      width: 400,
                      name: 'status',
                      label: 'Status',
                      items: [
                        DropdownMenuItem(value: true, child: Text('Active')),
                        DropdownMenuItem(value: false, child: Text('Inactive')),
                      ],
                      validator: employeeFormProvider.validateNonEmptyBool,
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 40, height: 80),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("Job Details"),
                  customTextField(
                    width: 400,
                    name: 'jobTitle',
                    label: 'Job Title',
                    validator: employeeFormProvider.validateNonEmpty,
                  ),
                  customDateField(
                    width: 400,
                    name: 'hireDate',
                    label: 'Hire Date',
                    validator: employeeFormProvider.validateDate,
                    enabled: !employeeFormProvider.isUpdate,
                  ),
                ],
              ),
              const SizedBox(width: 60),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("Qualification"),
                  customTextField(
                    width: 400,
                    name: 'qualificationName',
                    label: 'Qualification Name',
                    validator: employeeFormProvider.validateNonEmpty,
                  ),
                  customTextField(
                    width: 400,
                    name: 'qualificationInstituteName',
                    label: 'Qualification Institute Name',
                    validator: employeeFormProvider.validateNonEmpty,
                  ),
                  customDateField(
                    width: 400,
                    name: 'qualificationProcurementYear',
                    label: 'Qualification Procurement Year',
                    validator: employeeFormProvider.validateDate,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
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
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            label: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Color(0xFF6A5AE0),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          SizedBox(width: 10),
          TextButton.icon(
            onPressed: () async {
              final formState = employeeFormProvider.formKey.currentState;

              if (formState == null || !formState.saveAndValidate()) {
                debugPrint('Form is not valid or state is null');
                return;
              }

              if (formState.saveAndValidate()) {
                final id = widget.employee?.user.userId;

                final isInsert = widget.employee == null;

                final shouldProceed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(isInsert ? 'Add New Employee' : 'Save Changes'),
                    content: Text(
                      isInsert
                          ? 'Are you sure you want to add a new employee?'
                          : 'Are you sure you want to save the changes?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text('Confirm'),
                      ),
                    ],
                  ),
                );

                if (shouldProceed != true) return;

                final success = await employeeFormProvider.saveOrUpdate(
                  employeeFormProvider,
                  employeeProvider,
                  id,
                  onSaved: () {
                    loadData();
                  },
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? (employeeFormProvider.isUpdate
                                ? 'Employee updated.'
                                : 'Employee added.')
                          : 'Error.',
                    ),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );

                if (success && !employeeFormProvider.isUpdate) {
                  setState(() {});

                  employeeFormProvider.resetForm();
                }

                Provider.of<EmployeeProvider>(
                  context,
                  listen: false,
                ).markShouldRefresh();
              }
            },
            label: Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Color(0xFF6A5AE0),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/*
class CustomFormField extends StatelessWidget {
  final String name;
  final Widget child;
  final double width;

  const CustomFormField({
    super.key,
    required this.name,
    required this.child,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<dynamic>(
      name: name,
      builder: (FormFieldState<dynamic> field) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: SizedBox(
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Border box
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: field.hasError ? Colors.red : Colors.grey.shade400,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: child,
                ),

                if (field.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, left: 4.0),
                    child: Text(
                      field.errorText ?? '',
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}*/

Widget customTextField({
  required double width,
  required String name,
  required String label,
  String? hintText,
  String? prefixText,
  String? Function(String?)? validator,
  bool enabled = true,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16.0),
    child: SizedBox(
      width: width,
      child: FormBuilderField<String>(
        name: name,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        builder: (FormFieldState<String?> field) {
          final controller = TextEditingController(text: field.value);
          controller.selection = TextSelection.fromPosition(
            TextPosition(offset: controller.text.length),
          );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: TextField(
                  controller: controller,
                  enabled: enabled,
                  onChanged: field.didChange,
                  decoration: InputDecoration(
                    labelText: label,
                    border: InputBorder.none,
                    hintText: hintText,
                    prefixText: prefixText,
                  ),
                ),
              ),
              if (field.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, left: 4.0),
                  child: Text(
                    field.errorText ?? '',
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
            ],
          );
        },
      ),
    ),
  );
}

Widget customDropdownField<T>({
  required double width,
  required String name,
  required String label,
  required List<DropdownMenuItem<T>> items,
  String? Function(T?)? validator,
  bool enabled = true,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16.0),
    child: SizedBox(
      width: width,
      child: FormBuilderField<T>(
        name: name,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        builder: (FormFieldState<T?> field) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: DropdownButton<T>(
                  isExpanded: true,
                  value: field.value,
                  onChanged: enabled ? field.didChange : null,
                  hint: Text(label),
                  underline: const SizedBox(),
                  items: items,
                ),
              ),
              if (field.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, left: 4.0),
                  child: Text(
                    field.errorText ?? '',
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
            ],
          );
        },
      ),
    ),
  );
}

Widget customDateField({
  required double width,
  required String name,
  required String label,
  String? Function(DateTime?)? validator,
  bool enabled = true,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16.0),

    child: SizedBox(
      width: width,
      child: FormBuilderField<DateTime>(
        name: name,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        builder: (field) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 17,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: InkWell(
                  onTap: enabled
                      ? () async {
                          final picked = await showDatePicker(
                            context: field.context,
                            initialDate: field.value ?? DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) field.didChange(picked);
                        }
                      : null,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      field.value != null
                          ? DateFormat('dd/MM/yyyy').format(field.value!)
                          : label,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
              if (field.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, left: 4.0),
                  child: Text(
                    field.errorText ?? '',
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
            ],
          );
        },
      ),
    ),
  );
}
