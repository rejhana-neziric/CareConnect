// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParticipantSearchObject _$ParticipantSearchObjectFromJson(
  Map<String, dynamic> json,
) => ParticipantSearchObject(
  fts: json['fts'] as String?,
  workshopId: (json['workshopId'] as num?)?.toInt(),
  userFirstNameGTE: json['userFirstNameGTE'] as String?,
  userLastNameGTE: json['userLastNameGTE'] as String?,
  workshopNameGTE: json['workshopNameGTE'] as String?,
  attendanceStatusNameGTE: json['attendanceStatusNameGTE'] as String?,
  registrationDateGTE: json['registrationDateGTE'] == null
      ? null
      : DateTime.parse(json['registrationDateGTE'] as String),
  registrationDateLTE: json['registrationDateLTE'] == null
      ? null
      : DateTime.parse(json['registrationDateLTE'] as String),
  additionalData: json['additionalData'] == null
      ? null
      : ParticipantAdditionalData.fromJson(
          json['additionalData'] as Map<String, dynamic>,
        ),
  userId: (json['userId'] as num?)?.toInt(),
  page: (json['page'] as num?)?.toInt(),
  sortBy: json['sortBy'] as String?,
  sortAscending: json['sortAscending'] as bool?,
  includeTotalCount: json['includeTotalCount'] as bool?,
  retrieveAll: json['retrieveAll'] as bool?,
);

Map<String, dynamic> _$ParticipantSearchObjectToJson(
  ParticipantSearchObject instance,
) => <String, dynamic>{
  'fts': instance.fts,
  'workshopId': instance.workshopId,
  'userFirstNameGTE': instance.userFirstNameGTE,
  'userLastNameGTE': instance.userLastNameGTE,
  'workshopNameGTE': instance.workshopNameGTE,
  'attendanceStatusNameGTE': instance.attendanceStatusNameGTE,
  'registrationDateGTE': instance.registrationDateGTE?.toIso8601String(),
  'registrationDateLTE': instance.registrationDateLTE?.toIso8601String(),
  'additionalData': instance.additionalData?.toJson(),
  'userId': instance.userId,
  'page': instance.page,
  'sortBy': instance.sortBy,
  'sortAscending': instance.sortAscending,
  'includeTotalCount': instance.includeTotalCount,
  'retrieveAll': instance.retrieveAll,
};
