import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:user/backend/auth/auth.dart';
import 'package:user/backend/base.dart';
import 'package:user/classes/likesList_class.dart';

class LikeslistApiService {
  Future<List<Likeslist>> fetchLikeslists() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Failed to retrieve token');
    }

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response =
        await http.get(Uri.parse('$baseUrl/likeslists/'), headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((e) => Likeslist.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load likeslists');
    }
  }

  Future<Likeslist> addLikeslist(String title) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Failed to retrieve token');
    }

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.post(
      Uri.parse('$baseUrl/likeslists/add/'),
      headers: headers,
      body: jsonEncode({'title': title}),
    );
    if (response.statusCode == 201) {
      return Likeslist.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create likeslist');
    }
  }

  Future<void> removeLikeslist(int id) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Failed to retrieve token');
    }

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http
        .delete(Uri.parse('$baseUrl/likeslists/$id/remove/'), headers: headers);
    if (response.statusCode != 204) {
      throw Exception('Failed to delete likeslist');
    }
  }

  Future<void> addProductToList(int listId, int productId) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Failed to retrieve token');
    }

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.post(
      Uri.parse('$baseUrl/likeslists/$listId/add_product/'),
      headers: headers,
      body: jsonEncode({'product_id': productId}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to add product');
    }
  }

  Future<void> removeProductFromList(int listId, int productId) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Failed to retrieve token');
    }

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.post(
      Uri.parse('$baseUrl/likeslists/$listId/remove_product/'),
      headers: headers,
      body: jsonEncode({'product_id': productId}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to remove product');
    }
  }
}
