import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:user/backend/base.dart';


//SINGUP
Future<bool> signup(String email, String fullName, String phoneNumber, String password) async {
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
Future<String?> login(String email, String password) async {
  final response = await http.post(
    Uri.parse('$baseUrl/login/'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'email': email,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final token = data['access'];
    return token;
  } else {
    print('Login failed: ${response.body}');
    return null;
  }
}


//TOKEN
Future<void> getProfile(String token) async {
  final response = await http.get(
    Uri.parse('$baseUrl/profile/'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    print('User data: ${response.body}');
  } else {
    print('Failed to get profile: ${response.body}');
  }
}
