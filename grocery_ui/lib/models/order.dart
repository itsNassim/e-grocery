import 'order_item.dart';

class Order {
  final String id;
  final String customerName;
  final String customerEmail;
  final DateTime date;
  final String status;
  final double totalAmount;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.customerName,
    required this.customerEmail,
    required this.date,
    required this.status,
    required this.totalAmount,
    required this.items,
  });
}