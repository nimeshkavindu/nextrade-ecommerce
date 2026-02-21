// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  price: (json['price'] as num).toDouble(),
  category: json['category'] as String,
  image: json['image'] as String,
  description: json['description'] as String,
  rating: (json['rating'] as num).toDouble(),
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'price': instance.price,
  'category': instance.category,
  'image': instance.image,
  'description': instance.description,
  'rating': instance.rating,
};
