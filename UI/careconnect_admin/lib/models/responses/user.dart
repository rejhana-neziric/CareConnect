import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart'; // Don't open or edit this

@JsonSerializable()
class User {
  final int userId;
  final String firstName;
  final String lastName;
  final String? email;
  final String? phoneNumber;
  final String username;
  final DateTime? birthDate;
  final String gender;
  final String? address;
  final bool status;
  //final List<UserRoleResponse> usersRoles;

  User({
    required this.userId,
    required this.firstName,
    required this.lastName,
    this.email,
    this.phoneNumber,
    required this.username,
    this.birthDate,
    required this.gender,
    this.address,
    required this.status,
    //required this.usersRoles,
  });

  /// Connect the generated [_$EmployeeFromJson] function to the `fromJson`
  /// factory.
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// Connect the generated [_$UserToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
