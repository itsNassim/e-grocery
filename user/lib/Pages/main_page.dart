import 'package:flutter/material.dart';
import 'package:user/Pages/category_page.dart';
import 'package:user/Pages/home_page.dart';
import 'package:user/Pages/likes_page.dart';
import 'package:user/Pages/profile_page.dart';
import 'package:user/component/bootm_nav_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    CategoryPage(),
    LikesPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final toppadding = MediaQuery.of(context).padding.top;
    final bottompadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            if (_selectedIndex != 3) {
              setState(() {
                _selectedIndex += 1;
              });
            }
          } else if (details.primaryVelocity! > 0) {
            if (_selectedIndex != 0) {
              setState(() {
                _selectedIndex -= 1;
              });
            }
          }
        },
        child: SafeArea(
          child: SizedBox(
            height: height - toppadding - bottompadding,
            child: Stack(
              children: [
                _pages[_selectedIndex],
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: MediaQuery.of(context).viewInsets.bottom == 0
                      ? BootmNavBar(
                          onTabChange: (index) {
                            setState(() {
                              _selectedIndex = index;
                            });
                          },
                          selectedIndex: _selectedIndex,
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
