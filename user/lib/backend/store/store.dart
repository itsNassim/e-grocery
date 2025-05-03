import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:user/backend/base.dart';
import 'package:user/classes/shop_class.dart';

Future<List<ShopClass>> fetchStores() async {
  final response = await http.get(Uri.parse('$baseUrl/stores/'));

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((storeData) => ShopClass.fromJson(storeData)).toList();
  } else {
    throw Exception('Failed to load stores');
  }
}