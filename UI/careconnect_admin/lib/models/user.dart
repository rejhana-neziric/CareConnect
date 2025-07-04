import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart'; // Don't open or edit this

@JsonSerializable()
class User {
  String firstName;
  String lastName;
  String? email;
  String? phoneNumber;
  String username;

  User({
    required this.firstName,
    required this.lastName,
    this.email,
    this.phoneNumber,
    required this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
