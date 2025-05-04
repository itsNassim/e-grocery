import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:user/backend/base.dart';
import 'package:user/classes/shop_class.dart';
import 'package:hive/hive.dart';

Future<List<ShopClass>> fetchLikedStores() async {
  final token = await getToken();
  if (token == null) {
    throw Exception('Failed to retrieve token');
  }

  final headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  final response = await http.get(
    Uri.parse('$baseUrl/likedstores/'),
    headers: headers,
  );

  if (response.statusCode == 200) {
    final decoded = jsonDecode(response.body);

    if (decoded is Map<String, dynamic> && decoded.containsKey('stores')) {
      final List<dynamic> storeList = decoded['stores'];
      return storeList
          .map((storeData) =>
              ShopClass.fromJson(storeData as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Unexpected response format');
    }
  } else {
    throw Exception('Failed to load liked stores');
  }
}

Future<void> addStoreToLiked(int storeId) async {
  final token = await getToken();
  if (token == null) {
    throw Exception('Failed to retrieve token');
  }

  final headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  final response = await http.post(
    Uri.parse('$baseUrl/likedstores/add/'),
    headers: headers,
    body: jsonEncode({'store_id': storeId}),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to add store to liked list');
  }
}

Future<void> removeStoreFromLiked(int storeId) async {
  final token = await getToken();
  if (token == null) {
    throw Exception('Failed to retrieve token');
  }

  final headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  final response = await http.post(
    Uri.parse('$baseUrl/likedstores/remove/'),
    headers: headers,
    body: jsonEncode({'store_id': storeId}),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to remove store from liked list');
  }
}
