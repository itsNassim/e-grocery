import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/Backgrounds/backgound_1.dart';

import 'package:user/Pages/cart_page.dart';
import 'package:user/Pages/likes_page_products.dart';
import 'package:user/Pages/store_page.dart';

import 'package:user/blocs/liked_list_block.dart';
import 'package:user/blocs/liked_stores_bloc.dart';
import 'package:user/blocs/review_bloc.dart';
import 'package:user/blocs/shopping_cart_bloc.dart';

import 'package:user/classes/likesList_class.dart';
import 'package:user/classes/review_class.dart';

import 'package:user/component/liked_page_containe.dart';
import 'package:user/component/likes_page_products_tile.dart';
import 'package:user/component/search_bar/search_bar.dart';
import 'package:user/component/search_bar/search_bar_placeholder.dart';
import 'package:user/component/shopping_cart_icon.dart';
import 'package:user/component/store_tile.dart';

class LikesPage extends StatefulWidget {
  const LikesPage({super.key});

  @override
  State<LikesPage> createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {
  final List<String> items = [
    "All items",
    "Lists",
    "Stores",
  ];

  int? selectedItemIndex = 0;

  void _showFullScreenBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return LikedPageContaine(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          suggestion: ["Meat", "Mouth watering", "Dinner"],
          onCreate: (name) {
            context.read<LikeslistBloc>().add(AddLikesListEvent(name));
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final toppadding = MediaQuery.of(context).padding.top;
    final bottompadding = MediaQuery.of(context).padding.bottom;

    return BlocListener<LikeslistBloc, LikeslistState>(
      listener: (context, state) {
        setState(() {});
      },
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: SafeArea(
          child: SizedBox(
            height: height - toppadding - bottompadding,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Header Section
                  SizedBox(
                    height: 260,
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
                          top: 20,
                          left: 0,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              children: [
                                SearchBarPlaceholder(),
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
                                      itemCount: state.cartItems.length,
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: height * 0.13,
                          left: width * 0.2,
                          right: width * 0.2,
                          child: SizedBox(
                            width: width,
                            height: 30,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                final isSelected = index == selectedItemIndex;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedItemIndex = index;
                                    });
                                  },
                                  child: Container(
                                    width: 90,
                                    alignment: Alignment.center,
                                    child: Text(
                                      items[index],
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? const Color(0xffB7E98B)
                                            : const Color(0xff618185),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (selectedItemIndex != 2)
                    // Create New List
                    GestureDetector(
                      onTap: () => _showFullScreenBottomSheet(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 30,
                            width: 30,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xffFF6E57),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Create new list",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff0D2826),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 20),
                  if (selectedItemIndex == 0 || selectedItemIndex == 1)
                    BlocBuilder<LikeslistBloc, LikeslistState>(
                      builder: (context, state) {
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.likeslists.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LikesPageProducts(
                                          item: state.likeslists[index],
                                        ),
                                      ));
                                },
                                child: ProductsTile(
                                  width: width,
                                  item: state.likeslists[index],
                                  onPressed: (p0) {
                                    context
                                        .read<LikeslistBloc>()
                                        .add(RemoveLikesListEvent(
                                          state.likeslists[index],
                                        ));
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  if (selectedItemIndex == 0 || selectedItemIndex == 2)
                    BlocBuilder<LikedStoresBloc, LikedStoresState>(
                      builder: (context, state) {
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.shopsList.length,
                          itemBuilder: (context, index) {
                            final store = state.shopsList[index];
                            final isLiked = state.shopsList.contains(store);

                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          StorePage(store: store),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
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
                                      store: store,
                                      rating: double.parse(rating),
                                      widget: GestureDetector(
                                        onTap: () {
                                          if (isLiked) {
                                            context.read<LikedStoresBloc>().add(
                                                RemoveLikedStoreEvent(store));
                                          } else {
                                            context
                                                .read<LikedStoresBloc>()
                                                .add(AddLikedStoreEvent(store));
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
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
