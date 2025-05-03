import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:user/Pages/onboreding/onboarding_view.dart';
import 'package:user/authuntication/log_in.dart';
import 'package:user/classes/onboarding.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int currentPage = 0;
  late PageController controller;
  var box = Hive.box("mybox");

  List<OnboardingModel> items = [
    OnboardingModel(
      imageUrl: "assets/icons/1st.png",
      headline: 'Explore a Wide Range of Stores',
      description:
          'Discover a variety of trusted stores near you and find everything from fresh produce to household essentials in one place.',
    ),
    OnboardingModel(
      imageUrl: "assets/icons/2nd.png",
      headline: 'Get Exclusive Deals & Discounts',
      description:
          'Save more every day with personalized offers, daily discounts, and seasonal promotions curated just for you.',
    ),
    OnboardingModel(
      imageUrl: "assets/icons/3rd.png",
      headline: 'Create Your Shopping List',
      description:
          'Easily organize your groceries by making ingredient-based lists and never forget what you need during your next shopping trip.',
    ),
  ];

  onPageChange(int value) {
    setState(() {
      currentPage = value;
    });
  }

  _gotoNextPage() {
    if (currentPage < items.length - 1) {
      controller.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Cubic(0.25, 0.1, 0.25, 1.0),
      );
    } else {
      _gotoLoginSignUp();
    }
  }

  _gotoLoginSignUp() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LogInPage(),
      ),
    );
    box.put("onboarding", true);
  }

  @override
  void initState() {
    super.initState();
    controller = PageController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Expanded(
              flex: 8,
              child: PageView.builder(
                onPageChanged: onPageChange,
                itemCount: items.length,
                controller: controller,
                itemBuilder: (context, index) {
                  return OnboardingView(
                    data: items[index],
                  );
                },
              ),
            ),
            const Spacer(),
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                TweenAnimationBuilder(
                  duration: Duration(milliseconds: 300),
                  tween: Tween<double>(
                      begin: 0, end: (1 / items.length) * (currentPage + 1)),
                  curve: Cubic(0.68, -0.55, 0.265, 1.55),
                  builder: (context, double value, _) => SizedBox(
                    height: 70,
                    width: 70,
                    child: CircularProgressIndicator(
                      value: value,
                      strokeWidth: 6,
                      backgroundColor: Color(0xFFF2F2F2),
                      color: Color(0xFF00AD48),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _gotoNextPage,
                  style: ElevatedButton.styleFrom(shape: const CircleBorder()),
                  child: Icon(Icons.arrow_forward),
                ),
              ],
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
