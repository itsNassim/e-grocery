import 'package:user/classes/products_class.dart';
import 'package:user/classes/shopping_cart_class.dart';

enum OrderStatus { confirmed, processing, shipped, delivery, pickedup, cancelled  }

class OrderClass {
  final int ID;
  String Status;
  final String date;
  final String paymentMethod; // pickup or delivery with credit card
  final double total;
  final List<ShoppingCartItem> items;

  OrderClass({
    required this.ID,
    required this.Status,
    required this.date,
    required this.paymentMethod,
    required this.total,
    required this.items,
  });
}


