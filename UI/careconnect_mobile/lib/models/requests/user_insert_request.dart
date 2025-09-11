import 'package:json_annotation/json_annotation.dart';

part 'user_insert_request.g.dart';

@JsonSerializable()
class UserInsertRequest {
  final String firstName;
  final String lastName;
  final String? email;
  final String? phoneNumber;
  final String username;
  final String password;
  final String confirmationPassword;
  final DateTime? birthDate;
  final String gender;
  final String? address;

  UserInsertRequest({
    required this.firstName,
    required this.lastName,
    this.email,
    this.phoneNumber,
    required this.username,
    required this.password,
    required this.confirmationPassword,
    this.birthDate,
    required this.gender,
    this.address,
  });

  /// Connect the generated [_$EmployeeFromJson] function to the `fromJson`
  /// factory.
  factory UserInsertRequest.fromJson(Map<String, dynamic> json) =>
      _$UserInsertRequestFromJson(json);

  /// Connect the generated [_$UserToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$UserInsertRequestToJson(this);
}
