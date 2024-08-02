// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

History _$HistoryFromJson(Map<String, dynamic> json) => History(
      id: (json['id'] as num).toInt(),
      imageBlob: History._uint8ListFromJson(json['image_blob'] as List<int>),
      items: json['items'] as String,
      additionalCharges: json['additional_charges'] as String,
      additionalDiscounts: json['additional_discounts'] as String,
      total: (json['total'] as num).toDouble(),
      createdAt: (json['created_at'] as num).toInt(),
      deletedAt: (json['deleted_at'] as num?)?.toInt(),
      friendsList: json['friends_list'] as String,
    );

Map<String, dynamic> _$HistoryToJson(History instance) => <String, dynamic>{
      'id': instance.id,
      'image_blob': History._uint8ListToJson(instance.imageBlob),
      'items': instance.items,
      'additional_charges': instance.additionalCharges,
      'additional_discounts': instance.additionalDiscounts,
      'total': instance.total,
      'created_at': instance.createdAt,
      'deleted_at': instance.deletedAt,
      'friends_list': instance.friendsList,
    };
