// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_response_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageResponsePayload _$ImageResponsePayloadFromJson(
        Map<String, dynamic> json) =>
    ImageResponsePayload(
      data: json['data'] as Map<String, dynamic>,
      noTextDetected: json['no_text_detected'] as bool,
    );

Map<String, dynamic> _$ImageResponsePayloadToJson(
        ImageResponsePayload instance) =>
    <String, dynamic>{
      'data': instance.data,
      'no_text_detected': instance.noTextDetected,
    };
