import 'package:flutter/foundation.dart';
import '../models/order.dart';
import '../models/order_item.dart';

class OrderProvider with ChangeNotifier {
  final List<Order> _orders = [
    Order(
      id: '1001',
      customerName: 'John Doe',
      customerEmail: 'john@example.com',
      date: DateTime.now().subtract(const Duration(days: 1)),
      status: 'Processing',
      totalAmount: 125.99,
      items: [
        OrderItem(
          id: '1',
          name: 'Product 1',
          sku: 'SKU001',
          price: 49.99,
          quantity: 2,
        ),
        OrderItem(
          id: '2',
          name: 'Product 2',
          sku: 'SKU002',
          price: 26.01,
          quantity: 1,
        ),
      ],
    ),
    Order(
      id: '1002',
      customerName: 'Jane Smith',
      customerEmail: 'jane@example.com',
      date: DateTime.now().subtract(const Duration(days: 2)),
      status: 'Delivered',
      totalAmount: 89.95,
      items: [
        OrderItem(
          id: '3',
          name: 'Product 3',
          sku: 'SKU003',
          price: 89.95,
          quantity: 1,
        ),
      ],
    ),
    Order(
      id: '1003',
      customerName: 'Bob Johnson',
      customerEmail: 'bob@example.com',
      date: DateTime.now().subtract(const Duration(days: 3)),
      status: 'Pending',
      totalAmount: 199.99,
      items: [
        OrderItem(
          id: '4',
          name: 'Product 4',
          sku: 'SKU004',
          price: 199.99,
          quantity: 1,
        ),
      ],
    ),
    Order(
      id: '1004',
      customerName: 'Alice Brown',
      customerEmail: 'alice@example.com',
      date: DateTime.now().subtract(const Duration(days: 4)),
      status: 'Shipped',
      totalAmount: 149.98,
      items: [
        OrderItem(
          id: '5',
          name: 'Product 5',
          sku: 'SKU005',
          price: 74.99,
          quantity: 2,
        ),
      ],
    ),
    Order(
      id: '1005',
      customerName: 'Mike Wilson',
      customerEmail: 'mike@example.com',
      date: DateTime.now().subtract(const Duration(days: 5)),
      status: 'Cancelled',
      totalAmount: 59.99,
      items: [
        OrderItem(
          id: '6',
          name: 'Product 6',
          sku: 'SKU006',
          price: 59.99,
          quantity: 1,
        ),
      ],
    ),
  ];

  List<Order> get orders {
    return [..._orders];
  }

  // Add the getOrderById method
  Order? getOrderById(String id) {
    try {
      return _orders.firstWhere((order) => order.id == id);
    } catch (e) {
      // Return null if order not found
      return null;
    }
  }

  void updateOrderStatus(String orderId, String status) {
    final orderIndex = _orders.indexWhere((order) => order.id == orderId);
    if (orderIndex >= 0) {
      _orders[orderIndex] = Order(
        id: _orders[orderIndex].id,
        customerName: _orders[orderIndex].customerName,
        customerEmail: _orders[orderIndex].customerEmail,
        date: _orders[orderIndex].date,
        status: status,
        totalAmount: _orders[orderIndex].totalAmount,
        items: _orders[orderIndex].items,
      );
      notifyListeners();
    }
  }
}