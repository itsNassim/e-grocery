import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BootmNavBar extends StatelessWidget {
  const BootmNavBar({super.key});

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
            backgroundColor: Colors.white,
            hoverColor: Colors.transparent,
            tabBorderRadius: 50,
            tabActiveBorder: Border.all(color: Color(0xff064c4f), width: 1),
            tabBackgroundColor: Color(0xff064c4f).withOpacity(0.2),
            curve: Curves.easeInToLinear,
            gap: 9,
            color: Color.fromARGB(255, 46, 79, 6),
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
                text: 'Search',
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
