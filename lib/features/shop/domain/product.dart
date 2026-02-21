import 'package:freezed_annotation/freezed_annotation.dart';

// These two lines are required for the code generator to work
part 'product.freezed.dart';
part 'product.g.dart';

@freezed
sealed class Product with _$Product { 
  const factory Product({
    required int id,
    required String title,
    required double price,
    required String category,
    required String image,
    required String description,
    required double rating,
  }) = _Product;

  // This factory handles mapping the JSON data to the Dart object
  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}