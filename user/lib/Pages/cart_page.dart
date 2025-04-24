import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/Backgrounds/background_2.dart';
import 'package:user/blocs/shopping_cart_bloc.dart';
import 'package:user/classes/shop_class.dart';
import 'package:user/classes/shopping_cart_class.dart';
import 'package:user/component/shopping_cart-item_tile.dart';
import 'package:user/component/shopping_cart-store_tile.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late ScrollController _scrollController;
  int? selectedIndex;
  int quantity = 1;
  bool _hasPopped = false;
  bool isFavorite = false;
  bool emptyCart = false;
  double total = 0;

  void _increase() {
    setState(() {
      quantity++;
    });
  }

  void _decrease() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  Widget _buildTotalRow(String label, double value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 20 : 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: isBold ? Color(0xff154041) : Colors.black38,
          ),
        ),
        Text(
          "\$${value.toStringAsFixed(2)}",
          style: TextStyle(
            fontSize: isBold ? 20 : 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w700,
            color: Color(0xff154041),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset < -100 && !_hasPopped) {
        _hasPopped = true;
        Future.microtask(() {
          if (Navigator.of(context).canPop()) {
            Navigator.pop(context);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final toppadding = MediaQuery.of(context).padding.top;
    final bottompadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: height - toppadding - bottompadding,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                controller: _scrollController,
                child: Column(
                  children: [
                    SizedBox(height: height * 0.095),
                    Icon(
                      Icons.expand_more,
                      size: 50,
                      color: Colors.black45,
                    ),
                    SizedBox(height: height * 0.01),
                    BlocBuilder<ShoppingCartBloc, ShoppingCartState>(
                      builder: (context, state) {
                        if (state.cartItems.isEmpty) {
                          return SizedBox(
                            height: height * 0.65,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.remove_shopping_cart,
                                    size: 80,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    "Your cart is empty",
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Start adding products to your cart.",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        // Delay the setState to prevent build phase conflict
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            emptyCart = true;
                          });
                        });

                        // Group items by shop
                        final Map<ShopClass, List<ShoppingCartItem>>
                            shopGroups = {};
                        for (var item in state.cartItems) {
                          shopGroups
                              .putIfAbsent(item.product.shop, () => [])
                              .add(item);
                        }

                        // Calculate subtotal
                        double subtotal = 0;
                        for (var item in state.cartItems) {
                          subtotal += double.tryParse(item.product.price)! *
                              item.quantity;
                        }

                        const double deliveryFee = 5.0;
                        const double taxRate = 0.08;
                        double tax = subtotal * taxRate;
                        total = subtotal + deliveryFee + tax;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListView(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: shopGroups.entries.map((entry) {
                                final shop = entry.key;
                                final shopItems = entry.value;

                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: ShoppingCartStoreTile(
                                    shop: shop,
                                    shopItems: shopItems,
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _buildTotalRow("Subtotal", subtotal),
                                  const SizedBox(height: 8),
                                  _buildTotalRow("Delivery Fee", deliveryFee),
                                  const SizedBox(height: 8),
                                  _buildTotalRow("Taxes", tax),
                                  const Divider(height: 30, thickness: 1),
                                  _buildTotalRow("Total", total, isBold: true),
                                ],
                              ),
                            ),
                            const SizedBox(height: 80), // Space above footer
                          ],
                        );
                      },
                    ),
                    SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
            ),

            // Sticky Header
            SizedBox(
              height: height * 0.15,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: SecondBackGround(ScreenHeight: height),
                  ),
                  Positioned(
                    top: 20,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.arrow_back,
                                  size: 30,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          const Text(
                            "Product Detail",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          GestureDetector(
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(35),
                              ),
                              child: Center(
                                child: Image.asset(
                                  "assets/icons/shopping-cart.png",
                                  height: 30,
                                  width: 30,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Footer
            if (emptyCart)
              Positioned(
                bottom: 5,
                left: 0,
                right: 0,
                child: Container(
                  height: 70,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: BlocBuilder<ShoppingCartBloc, ShoppingCartState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffBBEA70),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          elevation: 5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.shopping_cart_checkout,
                              color: Color(0xff146139),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Checkout - \$${total.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff146139),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
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
          color: Color(0xff7C9D8C),
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: Center(
        child: TextButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xff7C9D8C),
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
