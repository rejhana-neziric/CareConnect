// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_search_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewSearchObject _$ReviewSearchObjectFromJson(Map<String, dynamic> json) =>
    ReviewSearchObject(
      fts: json['fts'] as String?,
      titleGTE: json['titleGTE'] as String?,
      isHidden: json['isHidden'] as bool?,
      publishDateGTE: json['publishDateGTE'] == null
          ? null
          : DateTime.parse(json['publishDateGTE'] as String),
      publishDateLTE: json['publishDateLTE'] == null
          ? null
          : DateTime.parse(json['publishDateLTE'] as String),
      stars: (json['stars'] as num?)?.toInt(),
      userFirstNameGTE: json['userFirstNameGTE'] as String?,
      userLastNameGTE: json['userLastNameGTE'] as String?,
      employeeFirstNameGTE: json['employeeFirstNameGTE'] as String?,
      employeeLastNameGTE: json['employeeLastNameGTE'] as String?,
      employeeId: (json['employeeId'] as num?)?.toInt(),
      additionalData: json['additionalData'] == null
          ? null
          : ReviewAdditionalData.fromJson(
              json['additionalData'] as Map<String, dynamic>,
            ),
      page: (json['page'] as num?)?.toInt(),
      sortBy: json['sortBy'] as String?,
      sortAscending: json['sortAscending'] as bool?,
      includeTotalCount: json['includeTotalCount'] as bool?,
      retrieveAll: json['retrieveAll'] as bool?,
    );

Map<String, dynamic> _$ReviewSearchObjectToJson(ReviewSearchObject instance) =>
    <String, dynamic>{
      'fts': instance.fts,
      'titleGTE': instance.titleGTE,
      'isHidden': instance.isHidden,
      'publishDateGTE': instance.publishDateGTE?.toIso8601String(),
      'publishDateLTE': instance.publishDateLTE?.toIso8601String(),
      'stars': instance.stars,
      'userFirstNameGTE': instance.userFirstNameGTE,
      'userLastNameGTE': instance.userLastNameGTE,
      'employeeFirstNameGTE': instance.employeeFirstNameGTE,
      'employeeLastNameGTE': instance.employeeLastNameGTE,
      'employeeId': instance.employeeId,
      'additionalData': instance.additionalData?.toJson(),
      'page': instance.page,
      'sortBy': instance.sortBy,
      'sortAscending': instance.sortAscending,
      'includeTotalCount': instance.includeTotalCount,
      'retrieveAll': instance.retrieveAll,
    };
