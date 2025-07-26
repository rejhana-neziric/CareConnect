// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientSearchObject _$ClientSearchObjectFromJson(Map<String, dynamic> json) =>
    ClientSearchObject(
      fts: json['fts'] as String?,
      firstNameGTE: json['firstNameGTE'] as String?,
      lastNameGTE: json['lastNameGTE'] as String?,
      email: json['email'] as String?,
      employmentStatus: json['employmentStatus'] as bool?,
      page: (json['page'] as num?)?.toInt(),
      sortBy: json['sortBy'] as String?,
      sortAscending: json['sortAscending'] as bool?,
      additionalData: json['additionalData'] == null
          ? null
          : ClientAdditionalData.fromJson(
              json['additionalData'] as Map<String, dynamic>,
            ),
      includeTotalCount: json['includeTotalCount'] as bool?,
    );

Map<String, dynamic> _$ClientSearchObjectToJson(ClientSearchObject instance) =>
    <String, dynamic>{
      'fts': instance.fts,
      'firstNameGTE': instance.firstNameGTE,
      'lastNameGTE': instance.lastNameGTE,
      'email': instance.email,
      'employmentStatus': instance.employmentStatus,
      'page': instance.page,
      'sortBy': instance.sortBy,
      'sortAscending': instance.sortAscending,
      'additionalData': instance.additionalData?.toJson(),
      'includeTotalCount': instance.includeTotalCount,
    };
