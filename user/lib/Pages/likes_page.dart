import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/Backgrounds/backgound_1.dart';
import 'package:user/Pages/likes_page_products.dart';
import 'package:user/blocs/shopping_cart_bloc.dart';
import 'package:user/classes/likesList_class.dart';
import 'package:user/component/liked_page_containe.dart';
import 'package:user/component/likes_page_products_tile.dart';
import 'package:user/component/search_bar.dart';
import 'package:user/component/shopping_cart_icon.dart';

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
            setState(() {
              final newList = Likeslist(title: name, productsList: []);
              golobalLikesList.add(newList);
            });
          },
        );
      },
    );
  }

  List<ProductsTile> get productTiles {
    final width = MediaQuery.of(context).size.width;
    return golobalLikesList.map((list) {
      return ProductsTile(
        width: width,
        Name: list.title,
        counter: list.productsList.length,
        productsList: list.productsList,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final toppadding = MediaQuery.of(context).padding.top;
    final bottompadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
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
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              CustomSearchBar(width: width),
                              const SizedBox(width: 12),
                              GestureDetector(
                                child: BlocBuilder<ShoppingCartBloc,
                                    ShoppingCartState>(
                                  builder: (context, state) {
                                    return ShoppingCartIcon(
                                      itemCount: state.cartItems.length,
                                    );
                                  },
                                ),
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

                // Dynamic Product Tiles
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: golobalLikesList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LikesPageProducts(
                                  title: golobalLikesList[index].title,
                                  productList:
                                      golobalLikesList[index].productsList,
                                ),
                              ));
                        },
                        child: productTiles[index],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
