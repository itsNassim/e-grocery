import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:user/backend/base.dart';

//Get User Info
Future<Map<String, dynamic>?> fetchUserInfo(String accessToken) async {
  final response = await http.get(
    Uri.parse('$baseUrl/token_info/'),
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    print('Failed to get user info: ${response.body}');
    return null;
  }
}

//modify info
Future<Map<String, dynamic>?> updateUserInfo(String? accessToken,
    String fullName, String email, String phoneNumber) async {
  final url = Uri.parse('$baseUrl/update-user/');
  final headers = {
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json',
  };

  final body = jsonEncode({
    'full_name': fullName,
    'email': email,
    'phone_number': phoneNumber,
  });

  try {
    final response = await http.put(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Failed to update user info: ${response.body}');
      return null;
    }
  } catch (e) {
    print('Error during updating user info: $e');
    return null;
  }
}

//Chnage Password
Future<bool> changeUserPassword({
  required String? accessToken,
  required String currentPassword,
  required String newPassword,
}) async {
  final response = await http.put(
    Uri.parse('$baseUrl/change-password/'),
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'current_password': currentPassword,
      'new_password': newPassword,
    }),
  );

  if (response.statusCode == 200) {
    print("Password changed successfully.");
    return true;
  } else {
    print("Failed to change password: ${response.body}");
    return false;
  }
}

//Delete Account
Future<bool> deleteUserAccount(String? accessToken) async {
  final response = await http.delete(
    Uri.parse('$baseUrl/delete-account/'),
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    print("Account deleted successfully.");
    return true;
  } else {
    print("Failed to delete account: ${response.body}");
    return false;
  }
}
