import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:user/backend/base.dart';
import 'package:user/classes/products_class.dart';
import 'package:user/classes/shop_class.dart';

Future<Map<String, dynamic>> searchProductsAndStores(String query) async {
  final uri = Uri.parse('$baseUrl/search/').replace(
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
