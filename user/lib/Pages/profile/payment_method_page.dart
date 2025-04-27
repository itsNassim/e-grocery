import 'package:flutter/material.dart';
import 'package:user/Backgrounds/background_2.dart';
import 'package:user/component/profile/default_card.dart';
import 'package:user/component/profile/new_card_row.dart';
import 'package:user/component/profile/payment_option_tile.dart';

class PaymentMethodPage extends StatelessWidget {
  const PaymentMethodPage({super.key});

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
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    const AddNewCardRow(),
                    const PaymentDefaultCard(),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          'Other Payment Option',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                        ),
                      ),
                    ),
                    PaymentOptionTile(
                      icon: 'https://i.imgur.com/7pI5714.png',
                      label: 'Paypal',
                      accountName: 'mypaypal@gmail.com',
                      imagename: "assets/icons/paypal.png",
                      onTap: () {},
                    ),
                    PaymentOptionTile(
                      icon: 'https://i.imgur.com/aRJj3iU.png',
                      label: 'Cash on Delivery',
                      accountName: 'Pay in Cash',
                      imagename: "assets/icons/payment-method.png",
                      onTap: () {},
                    ),
                    PaymentOptionTile(
                      icon: 'https://i.imgur.com/lLUcMC1.png',
                      label: 'Apple Pay',
                      accountName: 'applepay.com',
                      imagename: "assets/icons/apple-logo.png",
                      onTap: () {},
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
                              width: 75,
                            ),
                            const Text(
                              "Payment Option",
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
