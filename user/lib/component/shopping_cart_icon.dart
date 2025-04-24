import 'package:flutter/material.dart';

class ShoppingCartIcon extends StatelessWidget {
  final Key? cartKey;
  final int itemCount;

  const ShoppingCartIcon({
    this.cartKey,
    required this.itemCount,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: cartKey ?? null,
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(
            Icons.shopping_cart_outlined,
            size: 28,
            color: Colors.black87,
          ),
          if (itemCount > 0)
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    itemCount.toString(),
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
