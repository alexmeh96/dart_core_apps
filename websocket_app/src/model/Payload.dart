import 'package:json_annotation/json_annotation.dart';

part 'Payload.g.dart';

@JsonSerializable()
class Payload {
  final Object data;
  final int userId;

  Payload({required this.userId, required this.data});

  factory Payload.fromJson(Map<String, dynamic> json) => _$PayloadFromJson(json);

  Map<String, dynamic> toJson() => _$PayloadToJson(this);
}
