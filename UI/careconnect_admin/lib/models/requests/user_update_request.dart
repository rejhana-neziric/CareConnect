import 'package:json_annotation/json_annotation.dart';

part 'user_update_request.g.dart'; // Don't open or edit this

@JsonSerializable()
class UserUpdateRequest {
  final String? phoneNumber;
  final String? username;
  final String? password;
  final String? confirmationPassword;
  final String? email;
  final bool? status;
  final String? address;

  UserUpdateRequest({
    this.phoneNumber,
    this.username,
    this.password,
    this.confirmationPassword,
    this.email,
    this.status,
    this.address,
  });

  /// Connect the generated [_$EmployeeFromJson] function to the `fromJson`
  /// factory.
  factory UserUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$UserUpdateRequestFromJson(json);

  /// Connect the generated [_$UserToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$UserUpdateRequestToJson(this);
}
