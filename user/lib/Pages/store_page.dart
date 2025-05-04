import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/Backgrounds/backgound_1.dart';
import 'package:user/Pages/cart_page.dart';
import 'package:user/Pages/detail-page.dart';
import 'package:user/Pages/products_page.dart';
import 'package:user/backend/base.dart';
import 'package:user/backend/product/product_filter.dart';
import 'package:user/backend/user/user.dart';
import 'package:user/blocs/data_bloc.dart';
import 'package:user/blocs/liked_stores_bloc.dart';
import 'package:user/blocs/review_bloc.dart';
import 'package:user/blocs/shopping_cart_bloc.dart';
import 'package:user/classes/category_class.dart';
import 'package:user/classes/products_class.dart';
import 'package:user/classes/review_class.dart';
import 'package:user/classes/shop_class.dart';
import 'package:user/classes/shopping_cart_class.dart';
import 'package:user/classes/user_class.dart';
import 'package:user/component/FlyingItemAnimation.dart';
import 'package:user/component/Item_tile1.dart';
import 'package:user/component/curved_button.dart';
import 'package:user/component/scroll_list_tile.dart';
import 'package:user/component/search_bar/search_bar.dart';
import 'package:user/component/shopping_cart_icon.dart';
import 'package:user/component/store_tile3.dart';

class StorePage extends StatefulWidget {
  final ShopClass store;

  const StorePage({super.key, required this.store});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  final GlobalKey _cartKey = GlobalKey();
  final TextEditingController _textEditingController = TextEditingController();
  int selectedStars = 0;
  late ReviewBloc _reviewBloc;
  List<Category> categoryList = [];
  List<Product> productList = [];
  late User user;

  Offset _getWidgetPosition(GlobalKey key) {
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    return renderBox != null
        ? renderBox.localToGlobal(Offset.zero)
        : Offset.zero;
  }

  Future<List<Product>> getFilterList() async {
    final list = await fetchFilteredProducts(
      storeId: widget.store.id,
    );

    return list;
  }

  void _loadFilteredProducts() async {
    final filtered = await getFilterList();
    setState(() {
      productList = filtered;
    });
  }

  Future<User> getUser() async {
    try {
      final token = await getToken();
      final userInfo = await fetchUserInfo(token!);
      return User.fromJson(userInfo!);
    } catch (e) {
      throw Exception('Failed to load user: $e');
    }
  }

  void _getUser() async {
    final currentUser = await getUser();
    setState(() {
      user = currentUser;
    });
  }

  @override
  void initState() {
    super.initState();
    user = User(
      ID: 0,
      fullName: "",
      email: "",
      phoneNumber: "",
    );
    _reviewBloc = BlocProvider.of<ReviewBloc>(context);
    _loadFilteredProducts();
    _getUser();
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
                    _buildTopSection(height, width),
                    const SizedBox(height: 20),
                    _buildCategories(),
                    const SizedBox(height: 20),
                    _buildBestSellingSection(),
                    const SizedBox(height: 30),
                    _buildLeaveReviewSection(),
                    const SizedBox(height: 30),
                    _buildCustomerReviewsSection(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection(double height, double width) {
    return SizedBox(
      height: 370,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: FirstBackGround(
              ScreenHeight: height,
              color: const Color(0xFF652A70),
            ),
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
                  _buildBackButton(),
                  const Text(
                    "Store Profile",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  _buildCartIcon(),
                ],
              ),
            ),
          ),
          Positioned(
            top: height * 0.12,
            left: width / 2 - (width / 2 - 25),
            right: width / 2 - (width / 2 - 25),
            child: BlocBuilder<LikedStoresBloc, LikedStoresState>(
              builder: (context, state) {
                final isLiked = state.shopsList.contains(widget.store);

                return BlocBuilder<ReviewBloc, ReviewState>(
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

                    return StoreTile3(
                      height: height,
                      width: width,
                      store: widget.store,
                      rating: rating,
                      child: GestureDetector(
                        onTap: () {
                          if (isLiked) {
                            context
                                .read<LikedStoresBloc>()
                                .add(RemoveLikedStoreEvent(widget.store));
                          } else {
                            context
                                .read<LikedStoresBloc>()
                                .add(AddLikedStoreEvent(widget.store));
                          }
                        },
                        child: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          size: 22,
                          color: isLiked ? Colors.red : Colors.deepOrange,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
      ),
      child: Center(
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, size: 30, color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildCartIcon() {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CartPage()),
      ),
      child: BlocBuilder<ShoppingCartBloc, ShoppingCartState>(
        builder: (context, state) {
          return ShoppingCartIcon(
            cartKey: _cartKey,
            itemCount: state.cartItems.length,
          );
        },
      ),
    );
  }

  Widget _buildCategories() {
    return BlocBuilder<DataBloc, DataState>(
      builder: (context, state) {
        if (state is DataLoadedState) {
          categoryList = state.categories;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                "Categories",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoryList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductsPage(
                            selectedCategoryIndex: index + 1,
                            storeName: widget.store.name,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ScrollListTile(
                        category: categoryList[index],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBestSellingSection() {
    if (productList.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.inventory_2_outlined,
                size: 64,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'No Products Found',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'We couldn’t find any products matching your this store',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              "All Items",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 300,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: productList.length,
              itemBuilder: (context, index) {
                final itemKey = GlobalKey();
                final product = productList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: ItemTile1(
                    key: itemKey,
                    product: product,
                    curvedButton: CurvedButton(
                      height: 60,
                      width: 150,
                      icon: Icons.add,
                      color: const Color.fromARGB(255, 226, 239, 218),
                      onTap: () {
                        context.read<ShoppingCartBloc>().add(
                              AddProduct(
                                ShoppingCartItem(
                                  product: product,
                                  quantity: 1,
                                ),
                              ),
                            );
                        _startAddToCartAnimation(itemKey);
                      },
                      product: product,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(product: product),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      );
    }
  }

  Widget _buildLeaveReviewSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Leave a Review",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _textEditingController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "Write your review here...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Your Rating:",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(
              5,
              (index) => IconButton(
                onPressed: () => setState(() => selectedStars = index + 1),
                icon: Icon(
                  index < selectedStars ? Icons.star : Icons.star_border,
                  color: Colors.orange,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF652A70),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: _submitReview,
              child: const Text(
                "Submit Review",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitReview() {
    if (selectedStars != 0 && _textEditingController.text.isNotEmpty) {
      _reviewBloc.add(AddReviewEvent(
        widget.store.id,
        _textEditingController.text,
        selectedStars,
      ));
      _textEditingController.clear();
      setState(() {
        selectedStars = 0;
      });
    }
  }

  Widget _buildCustomerReviewsSection() {
    return BlocBuilder<ReviewBloc, ReviewState>(
      builder: (context, state) {
        if (state is ReviewLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ReviewLoadedState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  "Customer Reviews",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              if (state.reviews.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 40, horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.rate_review_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No Reviews Yet',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'This store hasn’t received any reviews yet.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: state.reviews.length,
                  itemBuilder: (context, index) {
                    final review = state.reviews[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8),
                      child: _buildReviewCard(review),
                    );
                  },
                ),
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _buildReviewCard(Review review) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage("assets/icons/user.png"),
                radius: 14,
                backgroundColor: Colors.white,
              ),
              const SizedBox(width: 10),
              Text(review.user.fullName,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          Text(review.text, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Row(
            children: List.generate(
              5,
              (i) => Icon(
                i < review.rating ? Icons.star : Icons.star_border,
                color: Colors.orange,
                size: 20,
              ),
            ),
          ),
          if (user.ID == review.user.ID)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _deleteReview(review);
                },
              ),
            ),
        ],
      ),
    );
  }

  void _deleteReview(Review review) {
    // Call the appropriate Bloc or method to delete the review
    // For example, calling ReviewBloc to delete the review:
    context
        .read<ReviewBloc>()
        .add(RemoveReviewEvent(widget.store.id, review.Id));
  }
}
