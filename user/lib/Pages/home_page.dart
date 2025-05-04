import 'package:circular_motion/circular_motion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:user/Pages/cart_page.dart';
import 'package:user/Pages/detail-page.dart';
import 'package:user/Pages/products_page.dart';
import 'package:user/Pages/store_page.dart';

import 'package:user/backend/category/category.dart';
import 'package:user/backend/product/product.dart';
import 'package:user/backend/store/store.dart';
import 'package:user/blocs/data_bloc.dart';
import 'package:user/blocs/liked_stores_bloc.dart';
import 'package:user/blocs/review_bloc.dart';
import 'package:user/blocs/shopping_cart_bloc.dart';

import 'package:user/classes/category_class.dart';
import 'package:user/classes/products_class.dart';
import 'package:user/classes/review_class.dart';
import 'package:user/classes/shop_class.dart';
import 'package:user/classes/shopping_cart_class.dart';

import 'package:user/component/FlyingItemAnimation.dart';
import 'package:user/component/Item_tile2.dart';
import 'package:user/component/curved_button.dart';
import 'package:user/component/item_tile1.dart';
import 'package:user/component/scroll_list_tile.dart';
import 'package:user/component/search_bar/search_bar.dart';
import 'package:user/component/search_bar/search_bar_placeholder.dart';
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

  late List<Category> categoryList;
  late List<ShopClass> storesList;
  late List<Product> productsList;

  @override
  void initState() {
    super.initState();
    categoryList = [];
    storesList = [];
    productsList = [];
  }

  void showErrorSnackbar(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $error'),
        backgroundColor: Colors.red,
      ),
    );
  }

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
      child: BlocBuilder<DataBloc, DataState>(builder: (context, state) {
        if (state is DataLoadedState) {
          categoryList = state.categories;
          storesList = state.stores;
          productsList = state.products;
        }
        return Scaffold(
          backgroundColor: Colors.grey[100],
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
                                    itemCount: categoryList.length,
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
                                            ),
                                          );
                                        },
                                        child: ScrollListTile(
                                          category: categoryList[index],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 20,
                                left: 0,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    children: [
                                      SearchBarPlaceholder(),
                                      const SizedBox(width: 12),
                                      GestureDetector(
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CartPage(),
                                          ),
                                        ),
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
                            itemCount: productsList.length,
                            itemBuilder: (context, index) {
                              final itemKey = GlobalKey();
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: ItemTile1(
                                  key: itemKey,
                                  product: productsList[index],
                                  curvedButton: CurvedButton(
                                    height: 60,
                                    width: 150,
                                    icon: Icons.add,
                                    color: const Color.fromARGB(
                                        255, 226, 239, 218),
                                    onTap: () {
                                      context.read<ShoppingCartBloc>().add(
                                            AddProduct(
                                              ShoppingCartItem(
                                                product: productsList[index],
                                                quantity: 1,
                                              ),
                                            ),
                                          );
                                      _startAddToCartAnimation(itemKey);
                                    },
                                    product: productsList[index],
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailPage(
                                          product: productsList[index],
                                        ),
                                      ),
                                    );
                                  },
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
                            itemCount: storesList.length,
                            itemBuilder: (context, index) {
                              ReviewBloc _reviewBloc =
                                  BlocProvider.of<ReviewBloc>(context);
                              _reviewBloc
                                  .add(FetchReviewsEvent(storesList[index].id));
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StorePage(
                                        store: ShopClass(
                                          id: storesList[index].id,
                                          imageUrl: storesList[index].imageUrl,
                                          name: storesList[index].name,
                                          email: storesList[index].email,
                                          phone: storesList[index].phone,
                                          address: storesList[index].address,
                                          openingTime:
                                              storesList[index].openingTime,
                                          closingTime:
                                              storesList[index].closingTime,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: BlocBuilder<ReviewBloc, ReviewState>(
                                      builder: (context, reviewState) {
                                    String rating = "0.00";
                                    if (reviewState is ReviewLoadedState &&
                                        reviewState.reviews.isNotEmpty) {
                                      final avg = reviewState.reviews
                                              .map((r) => r.rating)
                                              .reduce((a, b) => a + b) /
                                          reviewState.reviews.length;
                                      rating = avg.toStringAsFixed(2);
                                    }

                                    return StoreTile(
                                      store: storesList[index],
                                      rating: double.parse(rating),
                                      widget: BlocBuilder<LikedStoresBloc,
                                          LikedStoresState>(
                                        builder: (context, state) {
                                          final isLiked = state.shopsList
                                              .contains(storesList[index]);

                                          return GestureDetector(
                                            onTap: () {
                                              if (isLiked) {
                                                context
                                                    .read<LikedStoresBloc>()
                                                    .add(RemoveLikedStoreEvent(
                                                        storesList[index]));
                                              } else {
                                                context
                                                    .read<LikedStoresBloc>()
                                                    .add(AddLikedStoreEvent(
                                                        storesList[index]));
                                              }
                                            },
                                            child: Icon(
                                              isLiked
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: isLiked
                                                  ? Colors.red
                                                  : Colors.grey,
                                              size: 26,
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  }),
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
        );
      }),
    );
  }
}
