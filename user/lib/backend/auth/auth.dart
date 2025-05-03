import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:user/backend/base.dart';

//SINGUP
Future<bool> signup(
    String email, String fullName, String phoneNumber, String password) async {
  final response = await http.post(
    Uri.parse('$baseUrl/signup/'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': email,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'password': password,
    }),
  );

  if (response.statusCode == 201) {
    return true;
  } else {
    print('Signup failed: ${response.body}');
    return false;
  }
}

//LOGIN
Future<Map<String, dynamic>?> login(String email, String password) async {
  final url = Uri.parse('$baseUrl/login/');
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode({'email': email, 'password': password});

  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Login failed: ${response.body}');
      return null;
    }
  } catch (e) {
    print('Error during login: $e');
    return null;
  }
}

//TOKEN
Future<String?> refreshAccessToken(String refreshToken) async {
  final response = await http.post(
    Uri.parse('$baseUrl/refresh/'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'refresh': refreshToken}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['access'];
  } else {
    print('Failed to refresh token: ${response.body}');
    return null;
  }
}


