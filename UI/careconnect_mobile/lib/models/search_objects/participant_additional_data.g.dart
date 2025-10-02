// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant_additional_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParticipantAdditionalData _$ParticipantAdditionalDataFromJson(
  Map<String, dynamic> json,
) => ParticipantAdditionalData(
  isUserIncluded: json['isUserIncluded'] as bool?,
  isWorkshopIncluded: json['isWorkshopIncluded'] as bool?,
  isAttendanceStatusIncluded: json['isAttendanceStatusIncluded'] as bool?,
  isChildIncluded: json['isChildIncluded'] as bool?,
);

Map<String, dynamic> _$ParticipantAdditionalDataToJson(
  ParticipantAdditionalData instance,
) => <String, dynamic>{
  'isUserIncluded': instance.isUserIncluded,
  'isWorkshopIncluded': instance.isWorkshopIncluded,
  'isAttendanceStatusIncluded': instance.isAttendanceStatusIncluded,
  'isChildIncluded': instance.isChildIncluded,
};
