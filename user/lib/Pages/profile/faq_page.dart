import 'package:flutter/material.dart';
import 'package:user/Backgrounds/background_2.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Frequently Asked Questions",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6C1144),
                          ),
                        ),
                        SizedBox(height: 20),
                        _FaqItem(
                          question: "How do I place an order?",
                          answer:
                              "Browse products, add them to your cart, and proceed to checkout. Provide your delivery address and confirm your order.",
                        ),
                        SizedBox(height: 20),
                        _FaqItem(
                          question: "Can I cancel or modify my order?",
                          answer:
                              "Yes, you can cancel or modify your order before it is dispatched. Go to 'My Orders' and choose the option.",
                        ),
                        SizedBox(height: 20),
                        _FaqItem(
                          question: "What payment methods are accepted?",
                          answer:
                              "We currently support Cash on Delivery (COD). Online payment options will be added soon.",
                        ),
                        SizedBox(height: 20),
                        _FaqItem(
                          question: "How can I track my order?",
                          answer:
                              "You can track your order status from the 'My Orders' section in the app.",
                        ),
                        SizedBox(height: 20),
                        _FaqItem(
                          question:
                              "What if I receive the wrong or damaged items?",
                          answer:
                              "Please contact our support team immediately through the app or email. We will arrange a replacement or refund.",
                        ),
                        SizedBox(height: 20),
                        _FaqItem(
                          question: "Is there a delivery charge?",
                          answer:
                              "Delivery charges depend on your location and order amount. Free delivery is available for orders above a certain amount.",
                        ),
                        SizedBox(height: 20),
                        _FaqItem(
                          question: "How do I contact support?",
                          answer:
                              "You can reach us through the 'Help & Support' section inside the app or email us directly.",
                        ),
                      ],
                    ),
                  ),
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
                            const SizedBox(width: 140),
                            const Text(
                              "FAQ",
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

class _FaqItem extends StatelessWidget {
  final String question;
  final String answer;

  const _FaqItem({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          answer,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black54,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
