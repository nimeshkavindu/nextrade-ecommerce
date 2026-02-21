import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'cart_provider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the cart state
    final cartItems = ref.watch(cartProvider);
    
    // Colors from your Tailwind config
    const primaryTeal = Color(0xFF13ecc8);
    const brandBlue = Color(0xFF1a237e);
    const bgSurface = Color(0xFFf8f9fa);
    const textSecondary = Color(0xFF6b7280);

    // Calculate totals
    double subtotal = 0;
    cartItems.forEach((product, quantity) {
      subtotal += product.price * quantity;
    });
    const double shipping = 5.00;
    final double total = subtotal > 0 ? subtotal + shipping : 0;
    final int cartCount = ref.read(cartProvider.notifier).totalItems;

    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Top App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // We can hide the back button since we are using Bottom Navigation
                  const SizedBox(width: 40), 
                  Text(
                    'My Cart ($cartCount)',
                    style: const TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold, 
                      color: brandBlue,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(width: 40), // Spacer for balance
                ],
              ),
            ),

            // Main Content Area (Scrollable)
            Expanded(
              child: cartItems.isEmpty
                  ? const Center(
                      child: Text(
                        'Your cart is empty',
                        style: TextStyle(fontSize: 18, color: textSecondary),
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Column(
                        children: [
                          // Cart Items List
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: cartItems.length,
                            itemBuilder: (context, index) {
                              final product = cartItems.keys.elementAt(index);
                              final quantity = cartItems[product]!;

                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.grey.shade100),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.02),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    // Product Thumbnail
                                    Container(
                                      width: 96,
                                      height: 96,
                                      decoration: BoxDecoration(
                                        color: bgSurface,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          product.image,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => 
                                            const Icon(Icons.broken_image, color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    
                                    // Content
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  product.title,
                                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: brandBlue),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  // Hack to remove all units of this item from the cart
                                                  for(int i=0; i<quantity; i++){
                                                    ref.read(cartProvider.notifier).removeProduct(product);
                                                  }
                                                },
                                                child: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            product.category, // Using category as variant placeholder
                                            style: const TextStyle(fontSize: 12, color: textSecondary),
                                          ),
                                          const SizedBox(height: 12),
                                          
                                          // Price & Stepper
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                '\$${product.price.toStringAsFixed(2)}',
                                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: brandBlue),
                                              ),
                                              
                                              // Stepper Control
                                              Container(
                                                padding: const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: bgSurface,
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () => ref.read(cartProvider.notifier).removeProduct(product),
                                                      child: Container(
                                                        width: 28, height: 28,
                                                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2)]),
                                                        child: const Icon(Icons.remove, size: 16, color: brandBlue),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 32,
                                                      child: Center(child: Text('$quantity', style: const TextStyle(fontWeight: FontWeight.bold, color: brandBlue, fontSize: 14))),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () => ref.read(cartProvider.notifier).addProduct(product),
                                                      child: Container(
                                                        width: 28, height: 28,
                                                        decoration: BoxDecoration(color: brandBlue, borderRadius: BorderRadius.circular(6)),
                                                        child: const Icon(Icons.add, size: 16, color: Colors.white),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          
                          // Order Summary Section
                          if (cartItems.isNotEmpty)
                            Container(
                              margin: const EdgeInsets.only(top: 16, bottom: 24),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: bgSurface,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Order Summary', style: TextStyle(fontWeight: FontWeight.bold, color: brandBlue, fontSize: 16)),
                                  const SizedBox(height: 16),
                                  _buildSummaryRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}', textSecondary, Colors.black87),
                                  const SizedBox(height: 12),
                                  _buildSummaryRow('Shipping', '\$${shipping.toStringAsFixed(2)}', textSecondary, Colors.black87),
                                  const SizedBox(height: 12),
                                  _buildSummaryRow('Tax (Estimated)', '\$0.00', textSecondary, Colors.black87),
                                  
                                  // Dashed Divider
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        return Flex(
                                          direction: Axis.horizontal,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: List.generate((constraints.constrainWidth() / 10).floor(), (_) {
                                            return const SizedBox(width: 5, height: 1, child: DecoratedBox(decoration: BoxDecoration(color: Colors.grey)));
                                          }),
                                        );
                                      },
                                    ),
                                  ),
                                  
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: brandBlue)),
                                      Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 22, color: brandBlue, letterSpacing: -0.5)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
            ),

            // Bottom Action Bar
            Container(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade100)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 16, offset: const Offset(0, -4)),
                ],
              ),
              child: GestureDetector(
                onTap: subtotal > 0 ? () {
                  // Handle Checkout Action
                } : null,
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: subtotal > 0 ? primaryTeal : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: subtotal > 0 ? [BoxShadow(color: primaryTeal.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))] : null,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Proceed to Checkout',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: brandBlue),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: brandBlue, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for summary rows
  Widget _buildSummaryRow(String label, String value, Color labelColor, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: labelColor, fontSize: 14)),
        Text(value, style: TextStyle(fontWeight: FontWeight.w500, color: valueColor, fontSize: 14)),
      ],
    );
  }
}