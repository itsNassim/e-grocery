import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:user/backend/base.dart';
import 'package:user/backend/user/user.dart';
import 'package:user/classes/order_class.dart';
import 'package:user/classes/user_class.dart';

Future<void> createOrder(Order order) async {
  final token = await getToken();
  if (token == null) {
    throw Exception('Failed to retrieve token');
  }

  final headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  final userInfo = await fetchUserInfo(token);

  final userId = userInfo?['id'];

  final orderData = order.toJson();
  orderData['user'] = userId;
  orderData['payment_method'] = orderData['payment_method'].toLowerCase();

  final url = Uri.parse('$baseUrl/orders/create/');
  final response = await http.post(
    url,
    headers: headers,
    body: jsonEncode(orderData),
  );

  if (response.statusCode == 201) {
    print('Order created successfully!');
  } else {
    print('Error: ${response.statusCode} - ${response.body}');
    throw Exception('Failed to create order');
  }
}

Future<void> updateOrderStatus(int orderId, String status) async {
  final token = await getToken();
  if (token == null) {
    throw Exception('Failed to retrieve token');
  }

  final headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };
  final url = Uri.parse('$baseUrl/orders/$orderId/update-status/');
  final response = await http.patch(
    url,
    headers: headers,
    body: jsonEncode({"status": status}),
  );

  if (response.statusCode == 200) {
    print('Order status updated.');
  } else {
    print('Error: ${response.statusCode} - ${response.body}');
  }
}

Future<List<Order>> fetchOrders() async {
  final token = await getToken();
  if (token == null) {
    throw Exception('Failed to retrieve token');
  }

  final headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };
  final response = await http.get(
    Uri.parse('$baseUrl/orders/'),
    headers: headers,
  );

  if (response.statusCode == 200) {
    List data = jsonDecode(response.body);
    return data.map((e) => Order.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load orders');
  }
}
