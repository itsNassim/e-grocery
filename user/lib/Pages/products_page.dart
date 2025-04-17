import 'package:flutter/material.dart';
import 'package:user/Backgrounds/backgound_1.dart';
import 'package:user/Pages/detail-page.dart';
import 'package:user/component/FlyingItemAnimation.dart';
import 'package:user/component/Item_tile1.dart';
import 'package:user/component/search_bar.dart';

// ignore: must_be_immutable
class ProductsPage extends StatefulWidget {
  int selectedCategoryIndex;
  ProductsPage({
    super.key,
    required this.selectedCategoryIndex,
  });

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final List<String> categories = [
    "Fruits",
    "Vegetables",
    "Bakery",
    "Meat",
    "Dairy",
    "Snacks",
    "Drinks",
    "Frozen",
  ];

  late ScrollController _categoryScrollController;
  final GlobalKey _cartKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _categoryScrollController = ScrollController();
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
                      child: FirstBackGround(ScreenHeight: height),
                    ),
                    // Top Controls
                    Positioned(
                      top: 20,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
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

              // Product Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GridView.builder(
                  itemCount: 8,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ItemTile1(
                            key: itemKey,
                            imageName: "assets/icons/beetroot.png",
                            name: "Beetroot",
                            shopName: "Local shop",
                            weight: "500",
                            price: "17.29",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailPage(
                                    title: "Beetroot",
                                    weight: "500",
                                    price: "17.29",
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
  }
}
