import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/Backgrounds/background_2.dart';
import 'package:user/Pages/cart_page.dart';
import 'package:user/blocs/shopping_cart_bloc.dart';
import 'package:user/classes/likesList_class.dart';
import 'package:user/classes/products_class.dart';
import 'package:user/classes/shopping_cart_class.dart';
import 'package:user/component/liked_page_containe2.dart';
import 'package:user/component/read_more_text.dart';
import 'package:user/component/shopping_cart_icon.dart';
import 'package:user/component/stote_tile2.dart';

class DetailPage extends StatefulWidget {
  final Product product;

  DetailPage({
    super.key,
    required this.product,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late ScrollController _scrollController;
  int? selectedIndex;
  int quantity = 1;
  bool _hasPopped = false;
  bool isFavorite = false;

  void _increase() {
    setState(() {
      quantity++;
    });
  }

  void _decrease() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  void _showFullScreenBottomSheet(BuildContext context) async {
    bool wasAdded = await showModalBottomSheet<bool>(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) {
            return LikedPageContaine2(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              onCreate: (name) {
                setState(() {
                  final newList =
                      Likeslist(title: name, productsList: [widget.product]);
                  golobalLikesList.add(newList);
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                });
              },
              onAdd: (index) {
                setState(() {
                  golobalLikesList[index].productsList.add(widget.product);
                });
              },
            );
          },
        ) ??
        false;
    setState(() {
      isFavorite = wasAdded;
    });
  }

  @override
  void initState() {
    super.initState();
    for (var list in golobalLikesList) {
      if (list.productsList.contains(widget.product)) {
        isFavorite = true;
        break;
      }
    }
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
    List<String> parts = widget.product.price.split(".");
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final toppadding = MediaQuery.of(context).padding.top;
    final bottompadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.grey[50],
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
                    SizedBox(height: height * 0.095),
                    Icon(
                      Icons.expand_more,
                      size: 50,
                      color: Colors.black45,
                    ),
                    SizedBox(height: height * 0.001),
                    Center(
                      child: Stack(
                        children: [
                          ClipRect(
                            child: Image.asset(
                              widget.product.imageName,
                              height: width,
                              width: width,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            right: 10,
                            top: 0,
                            child: ClipRect(
                              child: Image.asset(
                                "assets/icons/halal_tag.png",
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.product.name,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${widget.product.weight}g',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    parts[0] + ".",
                                    style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      (parts.length > 1 ? parts[1] : "00") +
                                          "\$",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              if (!isFavorite) {
                                _showFullScreenBottomSheet(context);
                              } else {
                                setState(() {
                                  for (var list in golobalLikesList) {
                                    list.productsList.remove(widget.product);
                                  }
                                  isFavorite = false;
                                });
                              }
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  width: 1,
                                  color: Colors.black,
                                ),
                                color: Colors.white,
                              ),
                              child: isFavorite
                                  ? Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    )
                                  : Icon(Icons.favorite_border_outlined),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ReadMoreText(
                        text: widget.product.description,
                        maxLines: 3,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Other stores",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 700,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: StoreTile2(
                                imageName: "assets/icons/shopping-cart.png",
                                isSelected: selectedIndex == index,
                                price: "15.15",
                                rating: 4.5,
                                storeName: "T&T Food Market",
                                width: width,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 70,
                    ),
                  ],
                ),
              ),
            ),

            // Sticky Header
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
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            "Product Detail",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
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

            //footer
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 60,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 50,
                      width: width / 2 - 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Color(0xffF0F4EA),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _iconButton("-", _decrease),
                            Text(
                              '$quantity',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff7C9D8C),
                              ),
                            ),
                            _iconButton("+", _increase),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.read<ShoppingCartBloc>().add(
                              AddProduct(
                                ShoppingCartItem(
                                    product: widget.product,
                                    quantity: quantity),
                              ),
                            );
                      },
                      child: Container(
                          height: 50,
                          width: width / 2 - 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Color(0xffBBEA70),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Icon(
                                  Icons.shopping_cart_outlined,
                                  color: Color(0xff146139),
                                  size: 30,
                                ),
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
                          )),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconButton(String text, void Function() onPressed) {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: 2,
          color: Color(0xff7C9D8C),
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: Center(
        child: TextButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xff7C9D8C),
            ),
          ),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}
