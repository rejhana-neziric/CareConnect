import 'package:careconnect_admin/models/attendance_status.dart';
import 'package:careconnect_admin/providers/base_provider.dart';

class AttendanceStatusProvider extends BaseProvider<AttendanceStatus> {
  AttendanceStatusProvider() : super("AttendanceStatus");

  @override
  AttendanceStatus fromJson(data) {
    return AttendanceStatus.fromJson(data);
  }
}
