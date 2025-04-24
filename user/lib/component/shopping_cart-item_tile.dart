import 'package:flutter/material.dart';

import 'package:user/classes/shopping_cart_class.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ShoppingCartItemTile extends StatefulWidget {
  final ShoppingCartItem cartItem;
  final VoidCallback increment;
  final VoidCallback decrement;
  final void Function(BuildContext)? onPressed;
  ShoppingCartItemTile({
    super.key,
    required this.cartItem,
    required this.increment,
    required this.decrement,
    required this.onPressed,
  });

  @override
  State<ShoppingCartItemTile> createState() => _ShoppingCartItemTileState();
}

class _ShoppingCartItemTileState extends State<ShoppingCartItemTile> {
  @override
  Widget build(BuildContext context) {
    List<String> parts = widget.cartItem.product.price.split(".");
    return Slidable(
      endActionPane: ActionPane(
        motion: StretchMotion(),
        children: [
          SlidableAction(
            onPressed: widget.onPressed,
            icon: Icons.delete,
            backgroundColor: Colors.red,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(12.0),
              bottomRight: Radius.circular(12.0),
            ),
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[100],
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                widget.cartItem.product.imageName,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.cartItem.product.name} (${widget.cartItem.product.shop.name})",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${widget.cartItem.product.weight}g",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price Display
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${parts[0]}.",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              (parts.length > 1 ? parts[1] : "00") + "\$",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff154D41),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Quantity Controls
                      Row(
                        children: [
                          _quantityButton(Icons.remove, widget.decrement),
                          const SizedBox(width: 8),
                          Text(
                            widget.cartItem.quantity.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _quantityButton(Icons.add, widget.increment),
                        ],
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _quantityButton(IconData icon, VoidCallback onPressed) {
    return Container(
      height: 32,
      width: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: 1,
          color: const Color(0xff154D41),
        ),
      ),
      child: IconButton(
        icon: Icon(icon, size: 18, color: const Color(0xff154D41)),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        onPressed: onPressed,
      ),
    );
  }
}
