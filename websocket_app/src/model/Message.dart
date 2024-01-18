import 'package:json_annotation/json_annotation.dart';

import 'Payload.dart';

part 'Message.g.dart';

@JsonSerializable()
class Message {
  final String route;
  final Payload payload;

  Message({required this.route, required this.payload});

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
