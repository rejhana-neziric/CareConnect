import 'package:careconnect_admin/models/employee.dart';
import 'package:careconnect_admin/providers/base_provider.dart';

class EmployeeProvider extends BaseProvider<Employee> {
  EmployeeProvider() : super("Employee");

  @override
  Employee fromJson(data) {
    return Employee.fromJson(data);
  }
}
