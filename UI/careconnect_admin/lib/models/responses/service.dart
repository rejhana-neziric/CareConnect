import 'package:json_annotation/json_annotation.dart';

part 'service.g.dart'; // Don't open or edit this

@JsonSerializable()
class Service {
  final String name;
  final String? description;
  final double? price;
  final double? memberPrice;

  Service({required this.name, this.description, this.price, this.memberPrice});

  factory Service.fromJson(Map<String, dynamic> json) =>
      _$ServiceFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceToJson(this);
}
