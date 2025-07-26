import 'package:careconnect_admin/models/responses/age_group.dart';
import 'package:careconnect_admin/models/responses/gender_group.dart';
import 'package:json_annotation/json_annotation.dart';

part 'clients_child_statistics.g.dart';

@JsonSerializable(explicitToJson: true)
class ClientsChildStatistics {
  final int totalParents;
  final int totalChildren;
  final int employedParents;
  final int newClientsThisMonth;
  final List<AgeGroup> childrenPerAgeGroup;
  final List<GenderGroup> childrenPerGender;

  ClientsChildStatistics({
    required this.totalParents,
    required this.totalChildren,
    required this.employedParents,
    required this.newClientsThisMonth,
    required this.childrenPerAgeGroup,
    required this.childrenPerGender,
  });

  factory ClientsChildStatistics.fromJson(Map<String, dynamic> json) =>
      _$ClientsChildStatisticsFromJson(json);

  Map<String, dynamic> toJson() => _$ClientsChildStatisticsToJson(this);
}
