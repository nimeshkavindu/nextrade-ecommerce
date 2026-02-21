import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Import the MainScreen we just created
// Adjust this path if your folder structure is slightly different
import 'features/shop/presentation/main_screen.dart'; 

void main() {
  runApp(
    // ProviderScope stores the state of all the Riverpod providers we create
    const ProviderScope(
      child: NexTradeApp(),
    ),
  );
}

class NexTradeApp extends StatelessWidget {
  const NexTradeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NexTrade',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0D47A1)), 
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}