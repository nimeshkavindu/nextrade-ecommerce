import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/product.dart';

// 1. A basic provider to supply the repository to the rest of the app
final shopRepositoryProvider = Provider<ShopRepository>((ref) {
  return ShopRepository();
});

// 2. A FutureProvider that fetches the products. 
// Your UI will listen to this to show loading, error, or data states.
final productsProvider = FutureProvider<List<Product>>((ref) async {
  final repository = ref.read(shopRepositoryProvider);
  return repository.fetchProducts();
});

// 3. The actual Repository logic
class ShopRepository {
  Future<List<Product>> fetchProducts() async {
    // We add a tiny artificial delay here to simulate network latency
    // so you can see your loading spinners working in the UI!
    await Future.delayed(const Duration(milliseconds: 800));

    try {
      // Read the JSON file from the assets folder
      final String jsonString = await rootBundle.loadString('assets/data/products.json');
      
      // Decode the string into a List of Maps
      final List<dynamic> jsonList = jsonDecode(jsonString);
      
      // Convert the JSON list into a List of Product objects
      return jsonList.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }
}