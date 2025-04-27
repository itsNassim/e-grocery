import 'package:flutter/material.dart';
import 'package:user/Backgrounds/background_2.dart';
import 'package:user/component/profile/coupon_card.dart';

class CouponsPage extends StatefulWidget {
  const CouponsPage({super.key});

  @override
  State<CouponsPage> createState() => _CouponsPageState();
}

class _CouponsPageState extends State<CouponsPage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final toppadding = MediaQuery.of(context).padding.top;
    final bottompadding = MediaQuery.of(context).padding.bottom;
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: height - toppadding - bottompadding,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: height * 0.15),
                child: ListView(
                  children: [
                    CouponCard(
                      title: 'Black\nCoffee',
                      discounts: '41%',
                      expire: 'Exp-28/12/2020',
                      color: const Color(0xFF402FBE),
                    ),
                    CouponCard(
                      title: 'Handwash',
                      discounts: '23%',
                      couponBackground: "assets/coupon/coupon_background_2.png",
                      expire: 'Exp-28/12/2020',
                      color: const Color(0xFF398FE9),
                    ),
                    CouponCard(
                      title: 'Oreo\nBiscuit',
                      discounts: '50%',
                      couponBackground: "assets/coupon/coupon_background_3.png",
                      expire: 'Exp-28/12/2020',
                      color: const Color(0xFF30BD83),
                    ),
                    CouponCard(
                      title: 'Tuna\nFish',
                      discounts: '18%',
                      couponBackground: "assets/coupon/coupon_background_4.png",
                      expire: 'Exp-28/12/2020',
                      color: const Color(0xFF10C4DC),
                    ),
                  ],
                ),
              ),
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
                            SizedBox(
                              width: 70,
                            ),
                            const Text(
                              "Offers And Promo",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
