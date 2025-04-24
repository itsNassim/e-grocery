import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Organic Bananas',
      description: 'Fresh organic bananas from local farms',
      price: 2.99,
      stock: 150,
      category: 'Fruits & Vegetables',
      imageUrl: 'assets/images/fruits.jpg',
      sku: 'FRT-001',
    ),
    Product(
      id: '2',
      name: 'Fresh Milk',
      description: 'Pasteurized whole milk',
      price: 3.49,
      stock: 80,
      category: 'Dairy & Eggs',
      imageUrl: 'assets/images/placeholder.jpg',
      sku: 'DRY-001',
    ),
    Product(
      id: '3',
      name: 'Whole Wheat Bread',
      description: 'Freshly baked whole wheat bread',
      price: 4.99,
      stock: 45,
      category: 'Bakery',
      imageUrl: 'assets/images/grains.jpg',
      sku: 'BKY-001',
    ),
    Product(
      id: '4',
      name: 'Chicken Breast',
      description: 'Boneless, skinless chicken breast',
      price: 8.99,
      stock: 30,
      category: 'Meat & Seafood',
      imageUrl: 'assets/images/placeholder.jpg',
      sku: 'MET-001',
    ),
    Product(
      id: '5',
      name: 'Mixed Nuts',
      description: 'Assorted nuts, roasted and salted',
      price: 6.99,
      stock: 60,
      category: 'Snacks',
      imageUrl: 'assets/images/nuts.jpg',
      sku: 'SNK-001',
    ),
    Product(
      id: '6',
      name: 'Organic Apples',
      description: 'Fresh organic apples from local orchards',
      price: 4.49,
      stock: 120,
      category: 'Fruits & Vegetables',
      imageUrl: 'assets/images/fruits.jpg',
      sku: 'FRT-002',
    ),
    Product(
      id: '7',
      name: 'Greek Yogurt',
      description: 'Creamy Greek yogurt, plain',
      price: 5.99,
      stock: 40,
      category: 'Dairy & Eggs',
      imageUrl: 'assets/images/placeholder.jpg',
      sku: 'DRY-002',
    ),
    Product(
      id: '8',
      name: 'Quinoa',
      description: 'Organic white quinoa',
      price: 7.99,
      stock: 55,
      category: 'Grains',
      imageUrl: 'assets/images/grains.jpg',
      sku: 'GRN-001',
    ),
    Product(
      id: '9',
      name: 'Salmon Fillet',
      description: 'Wild-caught Atlantic salmon',
      price: 12.99,
      stock: 25,
      category: 'Meat & Seafood',
      imageUrl: 'assets/images/placeholder.jpg',
      sku: 'MET-002',
    ),
    Product(
      id: '10',
      name: 'Organic Spinach',
      description: 'Fresh organic baby spinach',
      price: 3.99,
      stock: 70,
      category: 'Fruits & Vegetables',
      imageUrl: 'assets/images/fruits.jpg',
      sku: 'FRT-003',
    ),
  ];

  Product? _selectedProduct;

  List<Product> get products {
    return [..._products];
  }

  Product? get selectedProduct {
    return _selectedProduct;
  }

  void setSelectedProduct(Product product) {
    _selectedProduct = product;
    notifyListeners();
  }

  void clearSelectedProduct() {
    _selectedProduct = null;
    notifyListeners();
  }

  void addProduct(Product product) {
    final newProduct = Product(
      id: DateTime.now().toString(),
      name: product.name,
      description: product.description,
      price: product.price,
      stock: product.stock,
      category: product.category,
      imageUrl: product.imageUrl,
      sku: product.sku,
    );
    _products.add(newProduct);
    notifyListeners();
  }

  void updateProduct(String id, Product updatedProduct) {
    final productIndex = _products.indexWhere((prod) => prod.id == id);
    if (productIndex >= 0) {
      _products[productIndex] = updatedProduct;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    _products.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }

  // Search products by query
  List<Product> searchProducts(String query) {
    if (query.isEmpty) {
      return [..._products];
    }
    
    final lowercaseQuery = query.toLowerCase();
    return _products.where((product) {
      return product.name.toLowerCase().contains(lowercaseQuery) ||
          product.description.toLowerCase().contains(lowercaseQuery) ||
          product.sku.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  // Filter products by category
  List<Product> filterByCategory(String category) {
    if (category == 'All Categories') {
      return [..._products];
    }
    
    return _products.where((product) => product.category == category).toList();
  }

  // Get all unique categories
  List<String> get categories {
    final Set<String> uniqueCategories = {};
    for (var product in _products) {
      uniqueCategories.add(product.category);
    }
    return ['All Categories', ...uniqueCategories];
  }
}