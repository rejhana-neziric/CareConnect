// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_availability_changes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeAvailabilityChanges _$EmployeeAvailabilityChangesFromJson(
  Map<String, dynamic> json,
) => EmployeeAvailabilityChanges(
  toCreate: (json['toCreate'] as List<dynamic>)
      .map(
        (e) => EmployeeAvailabilityInsertRequest.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
  toUpdate: (json['toUpdate'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(
      int.parse(k),
      EmployeeAvailabilityUpdateRequest.fromJson(e as Map<String, dynamic>),
    ),
  ),
  toDelete: (json['toDelete'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
);

Map<String, dynamic> _$EmployeeAvailabilityChangesToJson(
  EmployeeAvailabilityChanges instance,
) => <String, dynamic>{
  'toCreate': instance.toCreate,
  'toUpdate': instance.toUpdate.map((k, e) => MapEntry(k.toString(), e)),
  'toDelete': instance.toDelete,
};
