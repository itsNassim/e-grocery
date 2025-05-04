import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/Backgrounds/backgound_1.dart';
import 'package:user/Pages/cart_page.dart';
import 'package:user/Pages/detail-page.dart';
import 'package:user/backend/product/product_filter.dart';
import 'package:user/blocs/data_bloc.dart';
import 'package:user/blocs/liked_list_block.dart';
import 'package:user/blocs/shopping_cart_bloc.dart';
import 'package:user/classes/category_class.dart';
import 'package:user/classes/products_class.dart';
import 'package:user/classes/shop_class.dart';
import 'package:user/classes/shopping_cart_class.dart';
import 'package:user/component/FlyingItemAnimation.dart';
import 'package:user/component/curved_button.dart';
import 'package:user/component/filter_widget.dart';
import 'package:user/component/item_tile1.dart';
import 'package:user/component/search_bar/search_bar.dart';
import 'package:user/component/search_bar/search_bar_placeholder.dart';
import 'package:user/component/shopping_cart_icon.dart';

// ignore: must_be_immutable
class ProductsPage extends StatefulWidget {
  late int selectedCategoryIndex;
  String? storeName;
  ProductsPage({
    super.key,
    required this.selectedCategoryIndex,
    this.storeName,
  });

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<String> categories = ["All"];
  late List<Category> categoryList = [];
  late List<ShopClass> storesList = [];
  late List<Product> productsList = [];
  bool _added = false;
  String? selectedStore;
  String? sortOrder;
  double? maxPrice;
  double? minPrice;

  late ScrollController _categoryScrollController;
  final GlobalKey _cartKey = GlobalKey();

  Future<List<Product>> getFilterList() async {
    int? categoryId;

    if (categories[widget.selectedCategoryIndex] != "All") {
      try {
        categoryId = categoryList
            .firstWhere((category) =>
                category.name == categories[widget.selectedCategoryIndex])
            .id;
      } catch (e) {
        categoryId = null;
      }
    }

    int? storeId;

    if (selectedStore != "All") {
      try {
        storeId =
            storesList.firstWhere((store) => store.name == selectedStore).id;
      } catch (e) {
        storeId = null;
      }
    }

    final list = await fetchFilteredProducts(
      priceMax: maxPrice,
      priceMin: minPrice,
      ordering: sortOrder == "A-Z" ? "name" : "-name",
      storeId: storeId,
      categoryId: categoryId,
    );

    return list;
  }

  void _loadFilteredProducts() async {
    final filtered = await getFilterList();
    setState(() {
      productsList = filtered;
    });
  }

  void _checkStoreCategory() {
    if (widget.storeName != null) {
      print('Setting selectedStore to ${widget.storeName}');
      setState(() {
        selectedStore = widget.storeName;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _categoryScrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final itemWidth = 90.0;
      final screenWidth = MediaQuery.of(context).size.width;
      final offset = (itemWidth * widget.selectedCategoryIndex) -
          (screenWidth / 2) +
          (itemWidth / 2);

      _categoryScrollController.animateTo(
        offset.clamp(
          _categoryScrollController.position.minScrollExtent,
          _categoryScrollController.position.maxScrollExtent,
        ),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _categoryScrollController.dispose();
    super.dispose();
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

    return MultiBlocListener(
      listeners: [
        BlocListener<ShoppingCartBloc, ShoppingCartState>(
          listener: (context, state) {
            setState(() {});
          },
        ),
        BlocListener<LikeslistBloc, LikeslistState>(
          listener: (context, state) {
            setState(() {});
          },
        ),
      ],
      child: BlocBuilder<DataBloc, DataState>(
        builder: (context, state) {
          if (state is DataLoadedState) {
            categoryList = state.categories;
            storesList = state.stores;
            if (!_added) {
              if (!_added) {
                _added = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  categories.addAll(categoryList.map((e) => e.name).toList());
                  _checkStoreCategory();
                  _loadFilteredProducts();
                });
              }
            }
          }

          return Scaffold(
            backgroundColor: Colors.grey[100],
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Background Banner
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
                          // Top Controls
                          Positioned(
                            top: 20,
                            left: 0,
                            right: 0,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Back Button
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
                                          context
                                              .read<LikeslistBloc>()
                                              .add(RefreshLikesLists());
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
                                  // Title
                                  const Text(
                                    "Daily Foods",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  // Cart Icon
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
                          // Category Selector
                          Positioned(
                            top: height * 0.13,
                            left: 0,
                            right: 0,
                            child: SizedBox(
                              height: 30,
                              child: ListView.builder(
                                controller: _categoryScrollController,
                                scrollDirection: Axis.horizontal,
                                itemCount: categories.length,
                                itemBuilder: (context, index) {
                                  final isSelected =
                                      index == widget.selectedCategoryIndex;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        widget.selectedCategoryIndex = index;
                                      });

                                      final itemWidth = 90.0;
                                      final screenWidth =
                                          MediaQuery.of(context).size.width;
                                      final offset = (itemWidth * index) -
                                          (screenWidth / 2) +
                                          (itemWidth / 2);

                                      _categoryScrollController.animateTo(
                                        offset.clamp(
                                          _categoryScrollController
                                              .position.minScrollExtent,
                                          _categoryScrollController
                                              .position.maxScrollExtent,
                                        ),
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      );
                                      _loadFilteredProducts();
                                    },
                                    child: Container(
                                      width: 90,
                                      alignment: Alignment.center,
                                      child: Text(
                                        categories[index],
                                        style: TextStyle(
                                          fontSize: 18,
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

                    // Search Bar + Filter
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          SearchBarPlaceholder(),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () => showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              builder: (context) => FilterWidget(
                                maxPrice: this.maxPrice,
                                minPrice: this.minPrice,
                                selectedStore: this.selectedStore,
                                sortOrder: this.sortOrder,
                                onApply: (
                                    {required maxPrice,
                                    required minPrice,
                                    required selectedStore,
                                    required sortOrder}) {
                                  setState(() {
                                    this.maxPrice = maxPrice;
                                    this.minPrice = minPrice;
                                    this.selectedStore = selectedStore;
                                    this.sortOrder = sortOrder;
                                  });
                                  _loadFilteredProducts();
                                },
                              ),
                            ),
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(35),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.filter_list_rounded,
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    if (productsList.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 120.0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.filter_list_off,
                                size: 80,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                "No Products Found",
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Try adjusting your filters.",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Product Grid
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: GridView.builder(
                        itemCount: productsList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 0.48,
                        ),
                        itemBuilder: (context, index) {
                          final itemKey = GlobalKey();

                          return Builder(
                            builder: (context) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
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
                                                  quantity: 1),
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
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
