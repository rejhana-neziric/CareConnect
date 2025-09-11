import 'package:careconnect_mobile/models/responses/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'client.g.dart';

@JsonSerializable(explicitToJson: true)
class Client {
  final bool employmentStatus;
  final User? user;

  Client({required this.employmentStatus, this.user});

  factory Client.fromJson(Map<String, dynamic> json) => _$ClientFromJson(json);

  Map<String, dynamic> toJson() => _$ClientToJson(this);
}
