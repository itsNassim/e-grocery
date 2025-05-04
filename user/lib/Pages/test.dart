import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:user/backend/base.dart';
import 'dart:convert';

import 'package:user/classes/products_class.dart';
import 'package:user/classes/shop_class.dart';

// Replace with your actual backend URL
const String backendUrl = '$baseUrl/search/';

void main() {
  runApp(const MyApp());
}

// Root app widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product & Store Search',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const SearchPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Search Page
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<Product> _products = [];
  List<ShopClass> _stores = [];
  bool _isLoading = false;

  void _performSearch(String query) async {
    if (query.trim().isEmpty) return;

    try {
      final result = await searchProductsAndStores(query);
      setState(() {
        _products = result['products'];
        _stores = result['stores'];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Products & Stores')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Search products or stores...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _performSearch(_controller.text),
                ),
              ),
              onSubmitted: _performSearch,
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: ListView(
                  children: [
                    const Text('Products',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ..._products.map(
                      (p) => ListTile(
                        title: Text(p.name),
                        subtitle: Text(p.shop.name),
                        leading: Image.network(
                          p.imageName,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        trailing: Text('\$${p.price}'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Stores',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ..._stores.map(
                      (s) => ListTile(
                        title: Text(s.name),
                        subtitle: Text(s.address),
                        leading: Image.network(
                          s.imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// API call function
Future<Map<String, dynamic>> searchProductsAndStores(String query) async {
  final uri = Uri.parse('$backendUrl').replace(
    queryParameters: {'q': query},
  );

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    final products = (data['products'] as List)
        .map((json) => Product.fromJson(json))
        .toList();

    final stores = (data['stores'] as List)
        .map((json) => ShopClass.fromJson(json))
        .toList();

    return {
      'products': products,
      'stores': stores,
    };
  } else {
    throw Exception('Search failed: ${response.statusCode}');
  }
}
