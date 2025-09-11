import 'package:careconnect_mobile/models/responses/attendance_status.dart';
import 'package:careconnect_mobile/providers/base_provider.dart';

class AttendanceStatusProvider extends BaseProvider<AttendanceStatus> {
  AttendanceStatusProvider() : super("AttendanceStatus");

  @override
  AttendanceStatus fromJson(data) {
    return AttendanceStatus.fromJson(data);
  }
}
