import 'package:careconnect_admin/models/responses/attendance_status.dart';
import 'package:careconnect_admin/providers/base_provider.dart';

class AttendanceStatusProvider extends BaseProvider<AttendanceStatus> {
  AttendanceStatusProvider() : super("AttendanceStatus");

  @override
  AttendanceStatus fromJson(data) {
    return AttendanceStatus.fromJson(data);
  }

  @override
  int? getId(AttendanceStatus item) {
    return item.attendanceStatusId;
  }
}
