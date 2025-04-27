import 'package:circular_motion/circular_motion.dart';
import 'package:flutter/material.dart';

import 'package:user/Pages/cart_page.dart';
import 'package:user/Pages/detail-page.dart';
import 'package:user/Pages/products_page.dart';
import 'package:user/Pages/store_page.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/blocs/shopping_cart_bloc.dart';

import 'package:user/classes/category_class.dart';
import 'package:user/classes/products_class.dart';
import 'package:user/classes/shop_class.dart';
import 'package:user/classes/shopping_cart_class.dart';

import 'package:user/component/FlyingItemAnimation.dart';
import 'package:user/component/Item_tile2.dart';
import 'package:user/component/item_tile1.dart';
import 'package:user/component/scroll_list_tile.dart';
import 'package:user/component/search_bar.dart';
import 'package:user/component/shopping_cart_icon.dart';
import 'package:user/component/store_tile.dart';

import '../Backgrounds/backgound_1.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey _cartKey = GlobalKey();

  Offset _getWidgetPosition(GlobalKey key) {
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      return renderBox.localToGlobal(Offset.zero);
    } else {
      return Offset.zero;
    }
  }

  void _startAddToCartAnimation(GlobalKey itemKey) {
    final overlay = Overlay.of(context);
    final start = _getWidgetPosition(itemKey);
    final end = _getWidgetPosition(_cartKey);

    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) {
        return FlyingItemAnimation(
          startPosition: start,
          endPosition: end,
          onCompleted: () => entry.remove(),
        );
      },
    );

    overlay.insert(entry);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final toppadding = MediaQuery.of(context).padding.top;
    final bottompadding = MediaQuery.of(context).padding.bottom;

    return BlocListener<ShoppingCartBloc, ShoppingCartState>(
      listener: (context, state) {
        setState(() {});
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: SizedBox(
            height: height - toppadding - bottompadding,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 290,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: FirstBackGround(
                                ScreenHeight: height,
                                color: Color(0xFF013033),
                              ),
                            ),
                            Positioned(
                              top: -(height / 2) / 2,
                              left: -80,
                              right: -80,
                              child: SizedBox(
                                height: height * 0.55,
                                width: width,
                                child: CircularMotion.builder(
                                  behavior: HitTestBehavior.translucent,
                                  itemCount: GolbelCategoryList.length,
                                  builder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductsPage(
                                                selectedCategoryIndex:
                                                    index + 1,
                                              ),
                                            ));
                                      },
                                      child: ScrollListTile(
                                        category: GolbelCategoryList[index],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Positioned(
                              top: 10,
                              left: 0,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  children: [
                                    CustomSearchBar(width: width),
                                    const SizedBox(width: 12),
                                    GestureDetector(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CartPage(),
                                          )),
                                      child: BlocBuilder<ShoppingCartBloc,
                                          ShoppingCartState>(
                                        builder: (context, state) {
                                          return ShoppingCartIcon(
                                            cartKey: _cartKey,
                                            itemCount: state.cartItems.length,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "You might need",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductsPage(
                                      selectedCategoryIndex: 0,
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                "See more",
                                style: TextStyle(
                                  color: Color(0xffff7006),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 300,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: globalProductsList.length,
                          itemBuilder: (context, index) {
                            final itemKey = GlobalKey();
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: ItemTile1(
                                key: itemKey,
                                product: globalProductsList[index],
                                active: true,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailPage(
                                        product: globalProductsList[index],
                                      ),
                                    ),
                                  );
                                },
                                onTapCurvedButton: () {
                                  context.read<ShoppingCartBloc>().add(
                                        AddProduct(
                                          ShoppingCartItem(
                                              product:
                                                  globalProductsList[index],
                                              quantity: 1),
                                        ),
                                      );
                                  _startAddToCartAnimation(itemKey);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 8,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: ItemTile2(
                                backgroundImageName:
                                    "assets/background/background.png",
                                imageName: "assets/icons/beetroot.png",
                                name: "Beetroot",
                                time: "12:15",
                                delivery: "free delivery",
                                fontColor: const Color(0xFF6C1144),
                                timeColor:
                                    const Color.fromARGB(255, 185, 66, 133),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Featured store",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            InkWell(
                              onTap: () {},
                              child: const Text(
                                "See all",
                                style: TextStyle(
                                  color: Color(0xffff7006),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 230,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: globalShopsList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StorePage(
                                        store: globalShopsList[index],
                                      ),
                                    ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: StoreTile(
                                  store: globalShopsList[index],
                                  time: "12 minute",
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
