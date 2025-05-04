import 'package:user/classes/products_class.dart';
import 'package:user/classes/user_class.dart';

class OrderItem {
  final int id;
  final int quantity;
  final double price;
  final Product product;

  OrderItem({
    required this.id,
    required this.quantity,
    required this.price,
    required this.product,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] ?? 0,
      quantity: json['quantity'],
      price: double.parse(json['price']),
      product: Product.fromJson(json['product']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      "product_id": product.id,
      'quantity': quantity,
      'price': price,
    };
  }
}

class Order {
  final int id;
  final String status;
  final String createdAt;
  final String payment_method;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.status,
    required this.createdAt,
    required this.payment_method,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var itemsList = (json['items'] as List)
        .map((item) => OrderItem.fromJson(item))
        .toList();

    return Order(
      id: json['id'],
      status: json['status'],
      createdAt: json['date'] ?? "",
      payment_method: json['payment_method'],
      items: itemsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'payment_method': payment_method,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
