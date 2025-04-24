import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/blocs/shopping_cart_bloc.dart';
import 'package:user/classes/shop_class.dart';
import 'package:user/classes/shopping_cart_class.dart';
import 'package:user/component/shopping_cart-item_tile.dart';

class ShoppingCartStoreTile extends StatefulWidget {
  final ShopClass shop;
  final List<ShoppingCartItem> shopItems;

  const ShoppingCartStoreTile({
    super.key,
    required this.shop,
    required this.shopItems,
  });

  @override
  State<ShoppingCartStoreTile> createState() => _ShoppingCartStoreTileState();
}

class _ShoppingCartStoreTileState extends State<ShoppingCartStoreTile>
    with TickerProviderStateMixin {
  bool showList = false;
  final List<GlobalKey> collapsedKeys = [];
  final List<GlobalKey> expandedKeys = [];

  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    collapsedKeys
        .addAll(List.generate(widget.shopItems.length, (_) => GlobalKey()));
    expandedKeys
        .addAll(List.generate(widget.shopItems.length, (_) => GlobalKey()));

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleList() {
    setState(() {
      showList = !showList;
      if (showList) {
        _controller.forward(from: 0); // Start the animation
      } else {
        _controller.reverse(); // Reverse the animation
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Shop header with toggle
        GestureDetector(
          onTap: _toggleList,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(35),
                      child: Image.asset(
                        widget.shop.imageUrl,
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      widget.shop.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Icon(
                  showList
                      ? Icons.keyboard_arrow_down_rounded
                      : Icons.keyboard_arrow_up_rounded,
                  color: showList ? const Color(0xffA5583E) : Colors.black54,
                  size: 30,
                ),
              ],
            ),
          ),
        ),

        // Animated content with AnimatedSwitcher
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          switchInCurve: Curves.easeOutBack,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) {
            return ScaleTransition(
              scale: animation,
              child: child,
            );
          },
          child: showList
              ? Container(
                  key: const ValueKey('expanded'),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        color: Colors.black.withOpacity(0.05),
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: widget.shopItems.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Container(
                          key: expandedKeys[index],
                          child: ShoppingCartItemTile(
                            cartItem: item,
                            increment: () {
                              context.read<ShoppingCartBloc>().add(
                                    IncrementProduct(item.product),
                                  );
                            },
                            decrement: () {
                              context.read<ShoppingCartBloc>().add(
                                    DecrementProduct(item.product),
                                  );
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )
              : Container(
                  key: const ValueKey('collapsed'),
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  color: Colors.white70,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.shopItems.length,
                    itemBuilder: (context, index) {
                      final item = widget.shopItems[index];
                      return Container(
                        key: collapsedKeys[index],
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          shape: BoxShape.circle,
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Image.asset(
                          item.product.imageName,
                          fit: BoxFit.contain,
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                  ),
                ),
        ),
      ],
    );
  }
}
