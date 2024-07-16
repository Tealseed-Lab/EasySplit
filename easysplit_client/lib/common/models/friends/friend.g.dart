// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Friend _$FriendFromJson(Map<String, dynamic> json) => Friend(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      color: Friend._colorFromJson(json['color'] as String),
      createdAt: (json['created_at'] as num).toInt(),
      deletedAt: (json['deleted_at'] as num?)?.toInt(),
      isSelected: json['is_selected'] == null
          ? false
          : Friend._boolFromInt((json['is_selected'] as num).toInt()),
    );

Map<String, dynamic> _$FriendToJson(Friend instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'color': Friend._colorToJson(instance.color),
      'created_at': instance.createdAt,
      'deleted_at': instance.deletedAt,
      'is_selected': Friend._boolToInt(instance.isSelected),
    };
