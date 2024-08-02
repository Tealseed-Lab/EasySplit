import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'friend.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Friend {
  final int id;
  final String name;

  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  final Color color;

  final int createdAt;
  int? deletedAt;

  @JsonKey(fromJson: _boolFromInt, toJson: _boolToInt)
  bool isSelected;

  Friend({
    required this.id,
    required this.name,
    required this.color,
    required this.createdAt,
    this.deletedAt,
    this.isSelected = false,
  });

  bool get isDeleted => deletedAt != null;

  factory Friend.fromJson(Map<String, dynamic> json) => _$FriendFromJson(json);

  Map<String, dynamic> toJson() => _$FriendToJson(this);

  static Color _colorFromJson(String colorString) {
    return Color(int.parse(colorString, radix: 16)).withOpacity(1.0);
  }

  static String _colorToJson(Color color) {
    return color.value.toRadixString(16).padLeft(8, '0');
  }

  static bool _boolFromInt(int value) => value == 1;

  static int _boolToInt(bool value) => value ? 1 : 0;
}
