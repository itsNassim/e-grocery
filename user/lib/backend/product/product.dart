import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:user/backend/base.dart';
import 'package:user/classes/products_class.dart';

Future<List<Product>> fetchProducts() async {
  final url = Uri.parse('$baseUrl/products/');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((item) => Product.fromJson(item)).toList();
  } else {
    throw Exception("Failed to load products");
  }
}
