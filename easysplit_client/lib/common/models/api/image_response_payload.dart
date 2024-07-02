import 'package:json_annotation/json_annotation.dart';

part 'image_response_payload.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ImageResponsePayload {
  final Map<String, dynamic> data;
  final bool noTextDetected;

  ImageResponsePayload({
    required this.data,
    required this.noTextDetected,
  });

  // Factory constructor for creating a new `ImageResponsePayload` instance from a map.
  factory ImageResponsePayload.fromJson(Map<String, dynamic> json) =>
      _$ImageResponsePayloadFromJson(json);

  // Method for converting `ImageResponsePayload` instance to a map.
  Map<String, dynamic> toJson() => _$ImageResponsePayloadToJson(this);
}
