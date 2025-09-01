import 'package:careconnect_admin/models/responses/child.dart';
import 'package:careconnect_admin/providers/base_provider.dart';

class ChildProvider extends BaseProvider<Child> {
  ChildProvider() : super("Child");

  @override
  Child fromJson(data) {
    return Child.fromJson(data);
  }

  @override
  int? getId(Child item) {
    return item.childId;
  }
}
