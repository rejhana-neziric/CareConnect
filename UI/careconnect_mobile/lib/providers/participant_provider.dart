import 'package:careconnect_mobile/models/responses/participant.dart';
import 'package:careconnect_mobile/models/responses/search_result.dart';
import 'package:careconnect_mobile/models/search_objects/participant_additional_data.dart';
import 'package:careconnect_mobile/models/search_objects/participant_search_object.dart';
import 'package:careconnect_mobile/providers/base_provider.dart';

class ParticipantProvider extends BaseProvider<Participant> {
  ParticipantProvider() : super("Participant");

  @override
  Participant fromJson(data) {
    return Participant.fromJson(data);
  }

  @override
  int? getId(Participant item) {
    return item.user?.userId;
  }

  Future<SearchResult<Participant>?> loadData({
    String? fts,
    int? workshopId,
    String? userFirstNameGTE,
    String? userLastNameGTE,
    String? attendanceStatusNameGTE,
    DateTime? registrationDateGTE,
    DateTime? registrationDateLTE,
    int? userId,
    int page = 0,
    String? sortBy,
    bool sortAscending = true,
  }) async {
    final filterObject = ParticipantSearchObject(
      fts: fts,
      workshopId: workshopId,
      userFirstNameGTE: userFirstNameGTE,
      userLastNameGTE: userLastNameGTE,
      attendanceStatusNameGTE: attendanceStatusNameGTE,
      registrationDateGTE: registrationDateGTE,
      registrationDateLTE: registrationDateLTE,
      userId: userId,
      page: page,
      sortBy: sortBy,
      sortAscending: sortAscending,
      includeTotalCount: true,
      retrieveAll: true,
      additionalData: ParticipantAdditionalData(
        isAttendanceStatusIncluded: true,
        isUserIncluded: true,
        isWorkshopIncluded: true,
        isChildIncluded: true,
      ),
    );

    final filter = filterObject.toJson();

    final result = await get(filter: filter);

    notifyListeners();
    return result;
  }
}
