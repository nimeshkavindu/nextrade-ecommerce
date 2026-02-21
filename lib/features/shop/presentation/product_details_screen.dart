import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/product.dart';
import '../../cart/presentation/cart_provider.dart';

class ProductDetailsScreen extends ConsumerWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const primaryTeal = Color(0xFF13ecc8);
    const brandBlue = Color(0xFF1a237e);
    const textSecondary = Color(0xFF6b7280);
    const bgSurface = Color(0xFFf8f9fa);

    return Scaffold(
      backgroundColor: Colors.white,
      // We use the bottomNavigationBar for the sticky action bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade100)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 16, offset: const Offset(0, -4)),
          ],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Price', style: TextStyle(color: textSecondary, fontSize: 12, fontWeight: FontWeight.w500)),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryTeal,
                    foregroundColor: brandBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    // Add to cart state
                    ref.read(cartProvider.notifier).addProduct(product);
                    
                    // Show confirmation
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product.title} added to cart!'),
                        backgroundColor: brandBlue,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart_outlined),
                  label: const Text('Add to Cart', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image Area with Back Button
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 400,
                  decoration: const BoxDecoration(
                    color: bgSurface,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Hero(
                      tag: 'product_image_${product.id}', // Smooth transition animation
                      child: Image.network(
                        product.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 100, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCircleButton(Icons.arrow_back, () => Navigator.pop(context)),
                        _buildCircleButton(Icons.share_outlined, () {}),
                      ],
                    ),
                  ),
                ),
                // Mock Pagination Dots
                Positioned(
                  bottom: 24,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(width: 24, height: 8, decoration: BoxDecoration(color: primaryTeal, borderRadius: BorderRadius.circular(4))),
                      const SizedBox(width: 8),
                      Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.white70, shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.white70, shape: BoxShape.circle)),
                    ],
                  ),
                ),
              ],
            ),

            // Product Information
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.category.toUpperCase(),
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textSecondary, letterSpacing: 1.2),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.title,
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, height: 1.2, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),
                  
                  // Rating Row
                  Row(
                    children: [
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < product.rating.floor() ? Icons.star : Icons.star_half, 
                            color: Colors.amber, 
                            size: 20
                          );
                        }),
                      ),
                      const SizedBox(width: 8),
                      Text(product.rating.toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      const Text('(124 reviews)', style: TextStyle(color: textSecondary)),
                    ],
                  ),
                  
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                    child: Divider(color: bgSurface, thickness: 2),
                  ),

                  // Mock Color Selection
                  const Text('Select Color', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildColorOption(Colors.grey.shade300, isSelected: true, primaryTeal: primaryTeal),
                      _buildColorOption(brandBlue, isSelected: false, primaryTeal: primaryTeal),
                      _buildColorOption(const Color(0xFFE5D0C5), isSelected: false, primaryTeal: primaryTeal),
                    ],
                  ),
                  
                  const SizedBox(height: 32),

                  // Description
                  const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(
                    product.description,
                    style: const TextStyle(fontSize: 15, color: textSecondary, height: 1.6),
                  ),
                  
                  const SizedBox(height: 32),

                  // Specs Grid
                  Row(
                    children: [
                      Expanded(child: _buildSpecCard(Icons.water_drop, 'Water Resist', '50 Meters', brandBlue, bgSurface)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildSpecCard(Icons.battery_charging_full, 'Battery', '5 Days', brandBlue, bgSurface)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)],
        ),
        child: Icon(icon, color: Colors.black87),
      ),
    );
  }

  Widget _buildColorOption(Color color, {required bool isSelected, required Color primaryTeal}) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: isSelected ? primaryTeal : Colors.transparent, width: 2),
      ),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }

  Widget _buildSpecCard(IconData icon, String label, String value, Color brandBlue, Color bgSurface) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: bgSurface, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: brandBlue),
          const SizedBox(height: 8),
          Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}