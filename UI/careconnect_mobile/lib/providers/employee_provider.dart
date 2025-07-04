import 'package:careconnect_mobile/models/employee.dart';
import 'package:careconnect_mobile/providers/base_provider.dart';

class EmployeeProvider extends BaseProvider<Employee> {
  EmployeeProvider() : super("Employee");

  @override
  Employee fromJson(data) {
    return Employee.fromJson(data);
  }
}
