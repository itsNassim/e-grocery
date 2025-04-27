import 'package:user/classes/products_class.dart';
import 'package:user/classes/shopping_cart_class.dart';

enum OrderStatus { confirmed, processing, shipped, delivery, cancelled }

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

List<OrderClass> globalOrdersList = [
  OrderClass(
    ID: 1,
    Status: "confirmed",
    date: "2025-04-24",
    paymentMethod: "pickup",
    total: (double.parse(globalProductsList[0].price) * 2) +
        (double.parse(globalProductsList[1].price) * 1) +
        (double.parse(globalProductsList[2].price) * 2) +
        (double.parse(globalProductsList[3].price) * 1) +
        (double.parse(globalProductsList[4].price) * 2) +
        (double.parse(globalProductsList[5].price) * 1) +
        (double.parse(globalProductsList[6].price) * 2) +
        (double.parse(globalProductsList[7].price) * 1),
    items: [
      ShoppingCartItem(product: globalProductsList[0], quantity: 2),
      ShoppingCartItem(product: globalProductsList[1], quantity: 1),
      ShoppingCartItem(product: globalProductsList[2], quantity: 2),
      ShoppingCartItem(product: globalProductsList[3], quantity: 1),
      ShoppingCartItem(product: globalProductsList[4], quantity: 2),
      ShoppingCartItem(product: globalProductsList[5], quantity: 1),
      ShoppingCartItem(product: globalProductsList[6], quantity: 2),
      ShoppingCartItem(product: globalProductsList[7], quantity: 1),
    ],
  ),
  OrderClass(
    ID: 2,
    Status: "processing",
    date: "2025-04-25",
    paymentMethod: "credit card",
    total: (double.parse(globalProductsList[2].price) * 1),
    items: [
      ShoppingCartItem(product: globalProductsList[2], quantity: 1),
    ],
  ),
  OrderClass(
    ID: 3,
    Status: "shipped",
    date: "2025-04-26",
    paymentMethod: "pickup",
    total: (double.parse(globalProductsList[0].price) * 1) +
        (double.parse(globalProductsList[3].price) * 3),
    items: [
      ShoppingCartItem(product: globalProductsList[0], quantity: 1),
      ShoppingCartItem(product: globalProductsList[3], quantity: 3),
    ],
  ),
  OrderClass(
    ID: 4,
    Status: "delivery",
    date: "2025-04-26",
    paymentMethod: "credit card",
    total: (double.parse(globalProductsList[1].price) * 2),
    items: [
      ShoppingCartItem(product: globalProductsList[1], quantity: 2),
    ],
  ),
  OrderClass(
    ID: 5,
    Status: "cancelled",
    date: "2025-04-20",
    paymentMethod: "pickup",
    total: (double.parse(globalProductsList[2].price) * 1),
    items: [
      ShoppingCartItem(product: globalProductsList[2], quantity: 1),
    ],
  ),
  OrderClass(
    ID: 6,
    Status: "picked up",
    date: "2025-04-24",
    paymentMethod: "credit card",
    total: (double.parse(globalProductsList[0].price) * 2) +
        (double.parse(globalProductsList[1].price) * 1),
    items: [
      ShoppingCartItem(product: globalProductsList[0], quantity: 2),
      ShoppingCartItem(product: globalProductsList[1], quantity: 1),
    ],
  ),
  OrderClass(
    ID: 7,
    Status: "processing",
    date: "2025-04-25",
    paymentMethod: "pickup",
    total: (double.parse(globalProductsList[2].price) * 1),
    items: [
      ShoppingCartItem(product: globalProductsList[2], quantity: 1),
    ],
  ),
  OrderClass(
    ID: 8,
    Status: "shipped",
    date: "2025-04-26",
    paymentMethod: "credit card",
    total: (double.parse(globalProductsList[0].price) * 1) +
        (double.parse(globalProductsList[3].price) * 3),
    items: [
      ShoppingCartItem(product: globalProductsList[0], quantity: 1),
      ShoppingCartItem(product: globalProductsList[3], quantity: 3),
    ],
  ),
  OrderClass(
    ID: 9,
    Status: "delivery",
    date: "2025-04-26",
    paymentMethod: "pickup",
    total: (double.parse(globalProductsList[1].price) * 2),
    items: [
      ShoppingCartItem(product: globalProductsList[1], quantity: 2),
    ],
  ),
  OrderClass(
    ID: 10,
    Status: "cancelled",
    date: "2025-04-20",
    paymentMethod: "credit card",
    total: (double.parse(globalProductsList[2].price) * 1),
    items: [
      ShoppingCartItem(product: globalProductsList[2], quantity: 1),
    ],
  ),
];
