import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/product.dart';
import '../data/shop_repository.dart';
import '../../cart/presentation/cart_provider.dart';
import 'product_details_screen.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  // Local state to track which filter is active
  String _selectedCategory = 'All';

  // The categories that match our products.json data
  final List<String> _categories = ['All', 'Electronics', 'Fashion', 'Home'];

  @override
  Widget build(BuildContext context) {
    const royalBlue = Color(0xFF0a2463);
    const primaryTeal = Color(0xFF13ecc8);
    const bgColor = Color(0xFFf6f8f8);

    final productsState = ref.watch(productsProvider);

    return SafeArea(
      child: Container(
        color: bgColor,
        child: Column(
          children: [
            // 1. Custom App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button is disabled visually since we are in a root tab
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.transparent),
                    onPressed: () {},
                  ),
                  const Text(
                    'Categories',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: royalBlue, letterSpacing: -0.5),
                  ),
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.filter_list, color: Colors.black87),
                        onPressed: () {},
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(width: 8, height: 8, decoration: BoxDecoration(color: primaryTeal, shape: BoxShape.circle, border: Border.all(color: bgColor, width: 1.5))),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 2. Horizontal Category Filter
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = _selectedCategory == category;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12, bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? royalBlue : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: isSelected ? null : Border.all(color: Colors.grey.shade300),
                        boxShadow: isSelected ? [BoxShadow(color: royalBlue.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))] : null,
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey.shade600,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // 3. Filtered Product Grid
            Expanded(
              child: productsState.when(
                loading: () => const Center(child: CircularProgressIndicator(color: royalBlue)),
                error: (error, stack) => Center(child: Text('Error: $error')),
                data: (allProducts) {
                  // Filter the products based on the selected tab
                  final filteredProducts = _selectedCategory == 'All' 
                      ? allProducts 
                      : allProducts.where((p) => p.category == _selectedCategory).toList();

                  if (filteredProducts.isEmpty) {
                    return const Center(child: Text('No products found in this category.', style: TextStyle(color: Colors.grey)));
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.68, // Adjusted for the specific HTML card layout
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      return _buildProductCard(context, filteredProducts[index], royalBlue, primaryTeal);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Exact card layout from product_listing.html
  Widget _buildProductCard(BuildContext context, Product product, Color royalBlue, Color primaryTeal) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductDetailsScreen(product: product)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Area
            Container(
              height: 140,
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Hero(
                      tag: 'product_image_${product.id}',
                      child: Image.network(
                        product.image,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
                      child: const Icon(Icons.favorite_border, size: 16, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            // Details Area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.title,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: royalBlue),
                        ),
                        GestureDetector(
                          onTap: () {
                            ref.read(cartProvider.notifier).addProduct(product);
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${product.title} added to cart!'), duration: const Duration(seconds: 1), backgroundColor: primaryTeal),
                            );
                          },
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(color: primaryTeal, borderRadius: BorderRadius.circular(8)),
                            child: const Icon(Icons.add, color: Colors.white, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}