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
  final List<String> roles;

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
    required this.roles,
    //required this.usersRoles,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
