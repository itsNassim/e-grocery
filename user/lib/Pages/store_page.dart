import 'package:flutter/material.dart';
import 'package:user/Backgrounds/backgound_1.dart';
import 'package:user/Pages/detail-page.dart';
import 'package:user/Pages/products_page.dart';
import 'package:user/classes/category_class.dart';
import 'package:user/classes/products_class.dart';
import 'package:user/classes/review_class.dart';
import 'package:user/classes/shop_class.dart';
import 'package:user/classes/user_class.dart';
import 'package:user/component/FlyingItemAnimation.dart';
import 'package:user/component/Item_tile1.dart';
import 'package:user/component/scroll_list_tile.dart';
import 'package:user/component/search_bar.dart';
import 'package:user/component/store_tile3.dart';
import 'package:user/component/stote_tile2.dart';

class StorePage extends StatefulWidget {
  final ShopClass store;

  StorePage({
    super.key,
    required this.store,
  });

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  final GlobalKey _cartKey = GlobalKey();
  int selectedStars = 0;
  TextEditingController _textEditingController = TextEditingController();

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
                    // Top section with background and store tile
                    SizedBox(
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    "Store Profile",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  GestureDetector(
                                    child: Container(
                                      key: _cartKey,
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
                          Positioned(
                            top: height * 0.12,
                            left: width / 2 - (width / 2 - 25),
                            right: width / 2 - (width / 2 - 25),
                            child: StoreTile3(
                              height: height,
                              width: width,
                              store: widget.store,
                              rating: (golbelReviewList.fold(
                                          0, (sum, r) => sum + r.stars) /
                                      (golbelReviewList.isNotEmpty
                                          ? golbelReviewList.length
                                          : 1))
                                  .toStringAsFixed(2),
                            ),
                          )
                        ],
                      ),
                    ),

                    // Search and filter bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          CustomSearchBar(width: width),
                          const SizedBox(width: 12),
                          GestureDetector(
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

                    // Categories
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: GolbelCategoryList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductsPage(
                                    selectedCategoryIndex: index + 1,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ScrollListTile(
                                imageName: GolbelCategoryList[index].imageName,
                                title: GolbelCategoryList[index].name,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Best selling section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Best selling",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                              imageName: globalProductsList[index].imageName,
                              name: globalProductsList[index].name,
                              shopName: globalProductsList[index].shop.name,
                              weight: globalProductsList[index].weight,
                              price: globalProductsList[index].price,
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
                                _startAddToCartAnimation(itemKey);
                              },
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Leave a Review
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Leave a Review",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: List.generate(
                              5,
                              (index) => IconButton(
                                onPressed: () {
                                  setState(() {
                                    selectedStars = index + 1;
                                  });
                                },
                                icon: Icon(
                                  index < selectedStars
                                      ? Icons.star
                                      : Icons.star_border,
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
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                              ),
                              onPressed: () {
                                if (selectedStars != 0 &&
                                    _textEditingController.text.isNotEmpty) {
                                  setState(() {
                                    golbelReviewList.add(ReviewClass(
                                      user: globalUsersList[0],
                                      text: _textEditingController.text,
                                      stars: selectedStars,
                                    ));
                                  });
                                }
                              },
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
                    ),

                    const SizedBox(height: 30),

                    // Customer Reviews
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Customer Reviews",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: golbelReviewList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          AssetImage("assets/icons/user.png"),
                                      radius: 18,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      golbelReviewList[index].user.fullName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  golbelReviewList[index].text,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: List.generate(
                                    5,
                                    (i) => Icon(
                                      i < golbelReviewList[index].stars
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: Colors.orange,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
