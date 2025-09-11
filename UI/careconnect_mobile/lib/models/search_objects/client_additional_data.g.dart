// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_additional_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientAdditionalData _$ClientAdditionalDataFromJson(
  Map<String, dynamic> json,
) => ClientAdditionalData(
  isUserIncluded: json['isUserIncluded'] as bool?,
  isChildrenIncluded: json['isChildrenIncluded'] as bool?,
);

Map<String, dynamic> _$ClientAdditionalDataToJson(
  ClientAdditionalData instance,
) => <String, dynamic>{
  'isUserIncluded': instance.isUserIncluded,
  'isChildrenIncluded': instance.isChildrenIncluded,
};
