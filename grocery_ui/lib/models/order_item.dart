class OrderItem {
  final String id;
  final String name;
  final String sku;
  final double price;
  final int quantity;

  OrderItem({
    required this.id,
    required this.name,
    required this.sku,
    required this.price,
    required this.quantity,
  });
}