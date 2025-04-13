import 'package:circular_motion/circular_motion.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:user/component/Item_tile2.dart';
import 'package:user/component/bootm_nav_bar.dart';
import 'package:user/component/item_tile1.dart';
import 'package:user/component/scroll_list_tile.dart';
import 'package:user/component/search_bar.dart';
import 'package:user/component/store_tile.dart';

import '../Backgrounds/backgound_1.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final toppadding = MediaQuery.of(context).padding.top;
    final bottompadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SizedBox(
          height: height - toppadding - bottompadding,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 270,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: FirstBackGround(ScreenHeight: height),
                          ),
                          Positioned(
                            top: -(height / 2) / 2,
                            left: -80,
                            right: -80,
                            child: SizedBox(
                              height: height * 0.56,
                              width: width,
                              child: CircularMotion.builder(
                                behavior: HitTestBehavior.translucent,
                                itemCount: 10,
                                builder: (context, index) {
                                  return ScrollListTile(
                                    title: "cart",
                                    imageName: "assets/icons/shopping-cart.png",
                                  );
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
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
                                  )
                                ],
                              ),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "You might need",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            child: Text(
                              "See more",
                              style: TextStyle(
                                  color: Color(0xffff7006),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      height: 300,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 8,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: ItemTile1(
                              imageName: "assets/icons/beetroot.png",
                              name: "Beetroot",
                              shopName: "Local shop",
                              weight: "500",
                              price: "17.29",
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 8,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: ItemTile2(
                              backgroundImageName:
                                  "assets/background/background.png",
                              imageName: "assets/icons/beetroot.png",
                              name: "Beetroot",
                              time: "12:15",
                              delivery: "free delivery",
                              fontColor: Color(0xFF6C1144),
                              timeColor: Color.fromARGB(255, 185, 66, 133),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Featured store",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            child: Text(
                              "See all",
                              style: TextStyle(
                                  color: Color(0xffff7006),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      height: 230,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 8,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: StoreTile(
                              storeImage: "assets/icons/shopping-cart.png",
                              storeName: "T&T Food Market",
                              time: "12 minute",
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: MediaQuery.of(context).viewInsets.bottom == 0
                    ? BootmNavBar()
                    : SizedBox
                        .shrink(), // Hides the navbar when keyboard is open
              ),
            ],
          ),
        ),
      ),
    );
  }
}
