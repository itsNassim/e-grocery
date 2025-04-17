import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:user/Pages/category_page.dart';
import 'package:user/Pages/home_page.dart';

// ignore: must_be_immutable
class BootmNavBar extends StatelessWidget {
  void Function(int)? onTabChange;
  int selectedIndex;
  BootmNavBar({
    super.key,
    required this.onTabChange,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 40, right: 40, bottom: 24),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: GNav(
            selectedIndex: selectedIndex,
            onTabChange: onTabChange,
            backgroundColor: Colors.white,
            hoverColor: Colors.transparent,
            tabBorderRadius: 50,
            tabActiveBorder: Border.all(color: Color(0xff064c4f), width: 1),
            tabBackgroundColor: Color(0xff064c4f).withOpacity(0.2),
            curve: Curves.easeInToLinear,
            gap: 9,
            color: Color(0xff636B59),
            activeColor: Color(0xff064c4f),
            iconSize: 24,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            tabMargin: EdgeInsets.symmetric(horizontal: 8),
            tabs: [
              GButton(
                icon: Icons.home_outlined,
                text: 'Home',
              ),
              GButton(
                icon: Icons.format_list_bulleted_outlined,
                text: 'Category',
              ),
              GButton(
                icon: Icons.favorite_border_outlined,
                text: 'Likes',
              ),
              GButton(
                icon: Icons.local_shipping_outlined,
                text: 'Shipping',
              )
            ],
          ),
        ),
      ),
    );
  }
}
