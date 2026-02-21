import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Import our models and repository
import '../domain/product.dart';
import '../data/shop_repository.dart';
// Import the Cart Provider
import '../../cart/presentation/cart_provider.dart';
// Import the Product Details Screen
import 'product_details_screen.dart';

// 1. Change StatelessWidget to ConsumerWidget
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  // 2. Add WidgetRef to the build method
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const primaryColor = Color(0xFF3e68e5);
    const secondaryColor = Color(0xFF06b6d4);

    // 3. Watch the provider! This triggers the API/JSON fetch.
    final productsState = ref.watch(productsProvider);

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Header (Logo & Search)
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'NexTrade',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Search Bar Placeholder
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: Colors.grey),
                    hintText: 'Search products...',
                    hintStyle: TextStyle(color: Colors.grey),
                    suffixIcon: Icon(Icons.mic, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Category Filter Rail
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildCategoryChip('All', true, secondaryColor),
                    _buildCategoryChip('Electronics', false, secondaryColor),
                    _buildCategoryChip('Fashion', false, secondaryColor),
                    _buildCategoryChip('Home', false, secondaryColor),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Popular Products Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Popular Products',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'See All',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 4. Handle the AsyncValue states (Loading, Error, Data)
              productsState.when(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(color: primaryColor),
                  ),
                ),
                error: (error, stack) => Center(
                  child: Text(
                    'Error loading products: $error',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                data: (products) {
                  // Data loaded successfully! Build the grid.
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio:
                              0.70, // Slightly taller to fit real text
                        ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      // Pass context and ref down to the product card
                      return _buildProductCard(
                        context,
                        product,
                        primaryColor,
                        secondaryColor,
                        ref,
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(
    String label,
    bool isSelected,
    Color secondaryColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? secondaryColor : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isSelected ? null : Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey.shade700,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  // 5. Update the card to accept context, Product model, and WidgetRef
  Widget _buildProductCard(
    BuildContext context,
    Product product,
    Color primaryColor,
    Color secondaryColor,
    WidgetRef ref,
  ) {
    // Wrap the entire card in a GestureDetector for navigation
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Area
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    // Load the actual image from the URL, wrapped in a Hero widget for animation
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Hero(
                        tag:
                            'product_image_${product.id}', // Must match the tag on the Details Screen
                        child: Image.network(
                          product.image,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          // Show a loading spinner while the image downloads
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.broken_image,
                                color: Colors.grey,
                              ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite_border,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Product Details
            Text(
              product.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              product.category,
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: primaryColor,
                  ),
                ),
                // ADD TO CART BUTTON logic here!
                GestureDetector(
                  onTap: () {
                    // Add the item to the cart state
                    ref.read(cartProvider.notifier).addProduct(product);

                    // Clear existing snackbars to prevent stacking
                    ScaffoldMessenger.of(context).clearSnackBars();

                    // Show a quick success popup at the bottom of the screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product.title} added to cart!'),
                        duration: const Duration(seconds: 2),
                        backgroundColor: primaryColor,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
