// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payload _$PayloadFromJson(Map<String, dynamic> json) => Payload(
      userId: json['userId'] as int,
      data: json['data'] as Object,
    );

Map<String, dynamic> _$PayloadToJson(Payload instance) => <String, dynamic>{
      'data': instance.data,
      'userId': instance.userId,
    };
