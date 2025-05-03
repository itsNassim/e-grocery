import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/Backgrounds/backgound_1.dart';
import 'package:user/Pages/cart_page.dart';
import 'package:user/Pages/products_page.dart';
import 'package:user/backend/category/category.dart';
import 'package:user/blocs/data_bloc.dart';
import 'package:user/blocs/shopping_cart_bloc.dart';
import 'package:user/classes/category_class.dart';
import 'package:user/component/category_tile.dart';
import 'package:user/component/search_bar.dart';
import 'package:user/component/shopping_cart_icon.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late List<Category> categoryList;

  @override
  void initState() {
    super.initState();
    categoryList = [];
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final toppadding = MediaQuery.of(context).padding.top;
    final bottompadding = MediaQuery.of(context).padding.bottom;

    return BlocBuilder<DataBloc, DataState>(builder: (context, state) {
      if (state is DataLoadedState) {
        categoryList = state.categories;
      }
      return Scaffold(
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          child: SizedBox(
            height: height - toppadding - bottompadding,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 230,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: FirstBackGround(
                            ScreenHeight: height / 1.2,
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
                                CustomSearchBar(width: width),
                                SizedBox(
                                  width: 12,
                                ),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "All categories",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GridView.builder(
                      itemCount: categoryList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 2,
                      ),
                      itemBuilder: (context, index) {
                        return CategoryTile(
                          width: width,
                          category: categoryList[index],
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductsPage(
                                      selectedCategoryIndex: index + 1),
                                ));
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
