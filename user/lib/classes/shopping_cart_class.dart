import 'package:user/classes/products_class.dart';

class ShoppingCartItem {
  final Product product;
  final int quantity;

  ShoppingCartItem({
    required this.product,
    required this.quantity,
  });

  ShoppingCartItem copyWith({
    Product? product,
    int? quantity,
  }) {
    return ShoppingCartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  factory ShoppingCartItem.fromJson(Map<String, dynamic> json) {
    return ShoppingCartItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'quantity': quantity,
      };
}
