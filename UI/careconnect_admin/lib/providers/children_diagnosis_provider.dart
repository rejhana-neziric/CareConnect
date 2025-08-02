import 'package:careconnect_admin/models/responses/children_diagnosis.dart';
import 'package:careconnect_admin/providers/base_provider.dart';

class ChildrenDiagnosisProvider extends BaseProvider<ChildrenDiagnosis> {
  ChildrenDiagnosisProvider() : super("ChildrenDiagnosis");

  @override
  ChildrenDiagnosis fromJson(data) {
    return ChildrenDiagnosis.fromJson(data);
  }

  @override
  int? getId(ChildrenDiagnosis item) {
    return item.child.childId;
  }
}
