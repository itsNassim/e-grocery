import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:user/backend/base.dart';
import 'package:user/classes/category_class.dart';

Future<List<Category>> fetchCategories() async {
  final response = await http.get(Uri.parse('$baseUrl/categories/'));

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(response.body);
    return jsonData.map((json) => Category.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load categories');
  }
}
