import 'package:flutter/material.dart';
import 'package:user/Backgrounds/background_2.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

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
                      children: [
                        const Text(
                          "Privacy Policy",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6C1144),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "At eGrocery Shops, we value your privacy and are committed to protecting your personal information. "
                          "This Privacy Policy explains how we collect, use, and safeguard your data when you use our app.",
                          style: TextStyle(fontSize: 16, height: 1.5),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "1. Information We Collect",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "- Personal Information: Name, email address, phone number, and delivery address.\n"
                          "- Transaction Information: Orders placed, order history, and payment details.\n"
                          "- Location Information: Your city and delivery location (if you allow location access).",
                          style: TextStyle(fontSize: 16, height: 1.5),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "2. How We Use Your Information",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "- To process and deliver your orders.\n"
                          "- To communicate updates and order confirmations.\n"
                          "- To improve our app and services.\n"
                          "- To comply with legal obligations.",
                          style: TextStyle(fontSize: 16, height: 1.5),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "3. How We Protect Your Information",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "We implement strict security measures, including data encryption, secure servers, and restricted access policies, "
                          "to ensure your information remains confidential and protected.",
                          style: TextStyle(fontSize: 16, height: 1.5),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "4. Sharing of Information",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "- We do not sell your personal data to third parties.\n"
                          "- We may share necessary information with delivery partners and service providers to complete your orders.",
                          style: TextStyle(fontSize: 16, height: 1.5),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "5. Your Choices",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "- You can update or delete your account information at any time.\n"
                          "- You can opt out of promotional communications by contacting us.",
                          style: TextStyle(fontSize: 16, height: 1.5),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "6. Changes to This Policy",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "We may update this Privacy Policy from time to time. "
                          "We encourage you to review it regularly to stay informed about how we are protecting your data.",
                          style: TextStyle(fontSize: 16, height: 1.5),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          "If you have any questions or concerns, please contact our support team.",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              height: 1.5),
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
                            const SizedBox(width: 80),
                            const Text(
                              "Privacy Policy",
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
