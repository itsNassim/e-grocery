import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:user/backend/auth/auth.dart';
import 'package:user/backend/base.dart';
import 'package:user/classes/shopping_cart_class.dart';

class CartApiService {
  Future<List<ShoppingCartItem>> fetchCart() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Failed to retrieve token');
    }

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response =
        await http.get(Uri.parse('$baseUrl/cart/'), headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final items = (data['items'] as List?) ?? [];
      return items.map((item) => ShoppingCartItem.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load cart");
    }
  }

  Future<void> addToCart(String productId, int quantity) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Failed to retrieve token');
    }

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final body = json.encode({'product_id': productId, 'quantity': quantity});
    final response = await http.post(Uri.parse('$baseUrl/cart/add/'),
        headers: headers, body: body);
    if (response.statusCode != 201) throw Exception("Failed to add product");
  }

  Future<void> removeFromCart(String productId) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Failed to retrieve token');
    }

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.delete(
        Uri.parse('$baseUrl/cart/remove/$productId/'),
        headers: headers);
    if (response.statusCode != 200) throw Exception("Failed to remove product");
  }

  Future<void> updateQuantity(String productId, int quantity) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Failed to retrieve token');
    }

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final body = json.encode({'product_id': productId, 'quantity': quantity});
    final response = await http.patch(Uri.parse('$baseUrl/cart/update/'),
        headers: headers, body: body);
    if (response.statusCode != 200) {
      throw Exception("Failed to update quantity");
    }
  }

  Future<void> clearCart() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Failed to retrieve token');
    }

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response =
        await http.post(Uri.parse('$baseUrl/cart/clear/'), headers: headers);
    if (response.statusCode != 200) throw Exception("Failed to clear cart");
  }
}
