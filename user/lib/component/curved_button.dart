import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/blocs/shopping_cart_bloc.dart';
import 'package:user/classes/products_class.dart';
import 'package:user/classes/shopping_cart_class.dart';

class CurvedButton extends StatefulWidget {
  final double height;
  final double width;
  final IconData icon;
  final Color color;

  final void Function()? onTap;
  final Product product;

  const CurvedButton({
    super.key,
    required this.height,
    required this.width,
    required this.icon,
    required this.color,
    required this.product,
    this.onTap,
  });

  @override
  State<CurvedButton> createState() => _CurvedButtonState();
}

class _CurvedButtonState extends State<CurvedButton> {
  bool isQuantitySelector = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cartItems = context.read<ShoppingCartBloc>().state.cartItems;

      for (var list in cartItems) {
        if (list.product == widget.product) {
          setState(() {
            isQuantitySelector = true;
          });
          break;
        }
      }
    });
  }

  void _toggleToQuantitySelector() {
    if (!isQuantitySelector) {
      setState(() {
        isQuantitySelector = true;
      });
      widget.onTap?.call();
    }
  }

  void _increase() {
    context.read<ShoppingCartBloc>().add(IncrementProduct(widget.product));
  }

  void _decrease(int quantity) {
    final bloc = context.read<ShoppingCartBloc>();

    if (quantity > 1) {
      bloc.add(DecrementProduct(widget.product));
    } else {
      final bloc = context.read<ShoppingCartBloc>();
      final List<ShoppingCartItem> items = bloc.state.cartItems;

      final ShoppingCartItem item = items.firstWhere(
        (e) => e.product == widget.product,
        orElse: () => ShoppingCartItem(product: widget.product, quantity: 1),
      );
      bloc.add(RemoveProduct(item));
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color activeColor = const Color(0xFF7D9A4F);

    return GestureDetector(
      onTap: _toggleToQuantitySelector,
      child: ClipPath(
        clipper: CustomClip(),
        child: Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            color: isQuantitySelector ? activeColor : widget.color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: isQuantitySelector
              ? BlocBuilder<ShoppingCartBloc, ShoppingCartState>(
                  builder: (context, state) {
                    final item = state.cartItems.firstWhere(
                      (e) => e.product == widget.product,
                      orElse: () => ShoppingCartItem(
                          product: widget.product, quantity: 1),
                    );
                    final int quantity = item.quantity;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _iconButton("-", () => _decrease(quantity)),
                          Text(
                            '$quantity',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          _iconButton("+", _increase),
                        ],
                      ),
                    );
                  },
                )
              : Center(
                  child: Icon(widget.icon),
                ),
        ),
      ),
    );
  }

  Widget _iconButton(String text, void Function() onPressed) {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: 2,
          color: Colors.black,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: Center(
        child: TextButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}

class CustomClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, size.height * 0.15);

    path.quadraticBezierTo(
      size.width / 2,
      size.height / 3,
      size.width,
      size.height * 0.15,
    );

    path.lineTo(size.width, size.height * 0.8);

    path.quadraticBezierTo(
      size.width / 2,
      size.height * 0.95,
      0,
      size.height * 0.8,
    );

    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => true;
}
