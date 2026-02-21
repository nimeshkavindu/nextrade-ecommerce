import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home_screen.dart';
import '../../cart/presentation/cart_provider.dart';
import '../../cart/presentation/cart_screen.dart';
import 'categories_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // List of screens to swap out
  final List<Widget> _screens = [
    const HomeScreen(),
    const CategoriesScreen(), // Placeholder
    const CartScreen(),
    const Center(child: Text('Profile Screen')), // Placeholder
  ];

  @override
  Widget build(BuildContext context) {
    const royalBlue = Color(0xFF0a2463);
    const tealPrimary = Color(0xFF13ecc8);

    return Scaffold(
      backgroundColor: const Color(0xFFf6f8f8),
      body: _screens[_currentIndex],
      // Custom Bottom Nav Bar matching product_listing.html
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        padding: const EdgeInsets.only(
          bottom: 20,
          top: 10,
        ), // Safe area + padding
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              Icons.home_outlined,
              'Home',
              0,
              royalBlue,
              tealPrimary,
            ),
            _buildNavItem(
              Icons.grid_view,
              'Categories',
              1,
              royalBlue,
              tealPrimary,
            ),
            _buildCartNavItem(2, royalBlue, tealPrimary),
            _buildNavItem(
              Icons.person_outline,
              'Profile',
              3,
              royalBlue,
              tealPrimary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    int index,
    Color royalBlue,
    Color tealPrimary,
  ) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? royalBlue : Colors.grey.shade400;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartNavItem(int index, Color royalBlue, Color tealPrimary) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? royalBlue : Colors.grey.shade400;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Wrap the Stack in a Consumer so it listens to the cart state
          Consumer(
            builder: (context, ref, child) {
              // Read the total item count from the provider
              final cartCount = ref.watch(cartProvider.notifier).totalItems;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(Icons.shopping_cart_outlined, color: color, size: 26),
                  // Only show the badge if the cart has more than 0 items
                  if (cartCount > 0)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: tealPrimary,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$cartCount',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: royalBlue,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 4),
          Text(
            'Cart',
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
