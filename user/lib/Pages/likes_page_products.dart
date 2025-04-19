import 'package:flutter/material.dart';
import 'package:user/Backgrounds/background_2.dart';
import 'package:user/Pages/detail-page.dart';
import 'package:user/Pages/products_page.dart';
import 'package:user/classes/products_class.dart';
import 'package:user/component/Item_tile1.dart';
import 'package:user/component/read_more_text.dart';
import 'package:user/component/stote_tile2.dart'; // Assuming this shows product tiles

class LikesPageProducts extends StatefulWidget {
  final String title;
  final List<Product> productList;

  LikesPageProducts({
    super.key,
    required this.title,
    required this.productList,
  });

  @override
  State<LikesPageProducts> createState() => _LikesPageProductsState();
}

class _LikesPageProductsState extends State<LikesPageProducts> {
  late ScrollController _scrollController;
  bool _hasPopped = false;

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
      backgroundColor: Colors.grey[200],
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
                                  Text(
                                    widget.title,
                                    style: const TextStyle(
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
                          Positioned(
                            top: height * 0.095,
                            left: width * 0.5 - 25,
                            child: const Icon(
                              Icons.expand_more,
                              size: 50,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: GridView.builder(
                        itemCount: widget.productList.length + 1,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 0.47,
                        ),
                        itemBuilder: (context, index) {
                          if (index == widget.productList.length) {
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductsPage(
                                      selectedCategoryIndex: 0,
                                    ),
                                  )),
                              child: ClipPath(
                                clipper: CustomBottomClipper(),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                  ),
                                  height: 300,
                                  width: 150,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xffAB3E1F)),
                                          child: Icon(
                                            Icons.add,
                                            size: 50,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Text(
                                          "Add Product",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return ItemTile1(
                              imageName: widget.productList[index].imageName,
                              name: widget.productList[index].name,
                              shopName: widget.productList[index].shop,
                              weight: widget.productList[index].weight,
                              price: widget.productList[index].price,
                              active: false,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailPage(
                                      product: widget.productList[index],
                                    ),
                                  ),
                                );
                              },
                              onTapCurvedButton: () {},
                            );
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 200,
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                top: false,
                child: Container(
                  height: 60,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: 50,
                        width: width - 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: const Color(0xffBBEA70),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              SizedBox(width: 20),
                              Icon(
                                Icons.shopping_cart_outlined,
                                color: Color(0xff146139),
                                size: 30,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Add to cart",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff146139),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    Offset curveStartPoint = Offset(0, size.height * 0.93);
    Offset curveEndPoint = Offset(size.width, size.height * 0.92);
    path.lineTo(curveStartPoint.dx, curveStartPoint.dy);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      curveEndPoint.dx,
      curveEndPoint.dy,
    );
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}
