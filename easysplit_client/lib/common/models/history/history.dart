import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';

part 'history.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class History {
  final int id;

  @JsonKey(fromJson: _uint8ListFromJson, toJson: _uint8ListToJson)
  final Uint8List imageBlob;

  final String items;
  final String additionalCharges;
  final String additionalDiscounts;
  final double total;
  final int createdAt;
  int? deletedAt;
  final String friendsList;
  final String? location;

  History({
    required this.id,
    required this.imageBlob,
    required this.items,
    required this.additionalCharges,
    required this.additionalDiscounts,
    required this.total,
    required this.createdAt,
    this.deletedAt,
    required this.friendsList,
    this.location,
  });

  factory History.fromJson(Map<String, dynamic> json) =>
      _$HistoryFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryToJson(this);

  History copyWith({
    int? id,
    Uint8List? imageBlob,
    String? items,
    String? additionalCharges,
    String? additionalDiscounts,
    double? total,
    int? createdAt,
    int? deletedAt,
    String? friendsList,
    String? location,
  }) {
    return History(
      id: id ?? this.id,
      imageBlob: imageBlob ?? this.imageBlob,
      items: items ?? this.items,
      additionalCharges: additionalCharges ?? this.additionalCharges,
      additionalDiscounts: additionalDiscounts ?? this.additionalDiscounts,
      total: total ?? this.total,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      friendsList: friendsList ?? this.friendsList,
      location: location ?? this.location,
    );
  }

  static Uint8List _uint8ListFromJson(List<int> json) =>
      Uint8List.fromList(json);

  static List<int> _uint8ListToJson(Uint8List object) => object.toList();
}
