import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:user/backend/base.dart';
import 'package:user/classes/review_class.dart';

class ReviewRepository {
  Future<List<Review>> fetchReviews(int storeId) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Failed to retrieve token');
    }

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final response = await http.get(
      Uri.parse('$baseUrl/stores/$storeId/reviews/'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Review.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  Future<Review> addReview(int storeId, String text, int rating) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Failed to retrieve token');
    }

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final response = await http.post(
      Uri.parse('$baseUrl/stores/$storeId/reviews/add/'),
      headers: headers,
      body: jsonEncode({'text': text, 'rating': rating}),
    );

    if (response.statusCode == 201) {
      return Review.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add review');
    }
  }

  Future<void> removeReview(int storeId, int reviewId) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Failed to retrieve token');
    }

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final response = await http.delete(
      Uri.parse('$baseUrl/stores/$storeId/reviews/$reviewId/delete/'),
      headers: headers,
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to remove review');
    }
  }
}
