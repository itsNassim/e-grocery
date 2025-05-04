import 'package:http/http.dart' as http;
import 'package:user/backend/base.dart';
import 'dart:convert';

import 'package:user/classes/products_class.dart';

Future<List<Product>> fetchFilteredProducts({
  int? categoryId,
  int? storeId,
  double? priceMin,
  double? priceMax,
  String? ordering,
}) async {
  final Map<String, String> queryParams = {};
  if (categoryId != null) queryParams['category'] = '$categoryId';
  if (storeId != null) queryParams['store'] = '$storeId';
  if (priceMin != null) queryParams['price_min'] = '$priceMin';
  if (priceMax != null) queryParams['price_max'] = '$priceMax';
  if (ordering != null) queryParams['ordering'] = ordering;

  final uri = Uri.http(
    '10.0.2.2:8000', 
    '/api/products/filter/', 
    queryParams,
  );
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    List jsonList = json.decode(response.body);
    return jsonList.map((e) => Product.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load products');
  }
}
