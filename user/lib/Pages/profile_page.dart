import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:user/Backgrounds/backgound_1.dart';
import 'package:user/Pages/cart_page.dart';
import 'package:user/Pages/profile/about_us_page.dart';
import 'package:user/Pages/profile/all_orders_page.dart';
import 'package:user/Pages/profile/change_password_page.dart';
import 'package:user/Pages/profile/coupons_page.dart';
import 'package:user/Pages/profile/delete_account_page.dart';
import 'package:user/Pages/profile/faq_page.dart';
import 'package:user/Pages/profile/feedback_page.dart';
import 'package:user/Pages/profile/payment_method_page.dart';
import 'package:user/Pages/profile/personal_info_page.dart';
import 'package:user/Pages/profile/privacy_page.dart';
import 'package:user/authuntication/log_in.dart';
import 'package:user/backend/auth/auth.dart';
import 'package:user/backend/user/user.dart';
import 'package:user/blocs/shopping_cart_bloc.dart';
import 'package:user/classes/user_class.dart';
import 'package:user/component/search_bar/search_bar.dart';
import 'package:user/component/search_bar/search_bar_placeholder.dart';
import 'package:user/component/shopping_cart_icon.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User user;
  var box = Hive.box("mybox");

  @override
  void initState() {
    super.initState();
    user = User(
        ID: 0, fullName: "Unknown", email: "Unknown", phoneNumber: "Unknown");
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    final tokenMap = box.get("token");
    final refreshToken = tokenMap?["refresh"];

    final accessToken = await refreshAccessToken(refreshToken);
    if (accessToken != null) {
      final userInfo = await fetchUserInfo(accessToken);
      if (userInfo != null) {
        setState(() {
          user = User.fromJson(userInfo);
        });
      } else {
        print('Failed to fetch user info');
      }
    } else {
      print('Refresh token invalid or expired');
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final toppadding = MediaQuery.of(context).padding.top;
    final bottompadding = MediaQuery.of(context).padding.bottom;
    var box = Hive.box("mybox");

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: SizedBox(
          height: height - toppadding - bottompadding,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 350,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: FirstBackGround(
                              ScreenHeight: height + height / 7,
                              color: const Color(0xFF013033),
                            ),
                          ),
                          Positioned(
                            top: 20,
                            left: 0,
                            right: 0,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                children: [
                                  SearchBarPlaceholder(),
                                  const SizedBox(width: 12),
                                  GestureDetector(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CartPage()),
                                    ),
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
                          Positioned(
                            top: 85,
                            left: 50,
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.asset(
                                    "assets/icons/male_avatar.png",
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.fullName,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      "ID: ${user.ID * 50 + 100000}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Positioned(
                            top: (height + height / 7) * 0.18,
                            left: width * 0.07,
                            child: Container(
                              padding: const EdgeInsets.all(30),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12.withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  _buildTopIcon(
                                    Icons.local_shipping_outlined,
                                    "All Orders",
                                    () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AllOrdersPage(),
                                          ));
                                    },
                                  ),
                                  const SizedBox(width: 50),
                                  _buildTopIcon(
                                    Icons.confirmation_num_outlined,
                                    "coupons ",
                                    () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CouponsPage(),
                                          ));
                                    },
                                  ),
                                  const SizedBox(width: 50),
                                  _buildTopIcon(
                                    Icons.payment_outlined,
                                    "Payments",
                                    () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PaymentMethodPage(),
                                          ));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.symmetric(horizontal: 12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildProfileRow(
                            Icons.person_2_outlined,
                            "My Personal Info",
                            () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PersonalInfoPage(
                                      user: user,
                                    ),
                                  )).then((value) => setState(() {
                                    loadUserInfo();
                                  }));
                            },
                          ),
                          Divider(
                              color: Colors.grey[300],
                              thickness: 2,
                              height: 30),
                          _buildProfileRow(
                            Icons.lock_outline,
                            "Change Password",
                            () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ChangePasswordPage()));
                            },
                          ),
                          Divider(
                              color: Colors.grey[300],
                              thickness: 2,
                              height: 30),
                          _buildProfileRow(
                            Icons.delete_outline,
                            "Delete Account",
                            () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DeleteAccountPage(),
                                  ));
                            },
                          ),
                          Divider(
                              color: Colors.grey[300],
                              thickness: 2,
                              height: 30),
                          _buildProfileRow(
                            Icons.info_outline,
                            "About us",
                            () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AboutUsPage(),
                                  ));
                            },
                          ),
                          Divider(
                              color: Colors.grey[300],
                              thickness: 2,
                              height: 30),
                          _buildProfileRow(
                            Icons.policy_outlined,
                            "Privacy Policy",
                            () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PrivacyPage(),
                                  ));
                            },
                          ),
                          Divider(
                              color: Colors.grey[300],
                              thickness: 2,
                              height: 30),
                          _buildProfileRow(
                            Icons.help_outline,
                            "FAQ",
                            () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FaqPage(),
                                  ));
                            },
                          ),
                          Divider(
                              color: Colors.grey[300],
                              thickness: 2,
                              height: 30),
                          _buildProfileRow(
                            Icons.feedback_outlined,
                            "Feedback",
                            () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FeedbackPage(),
                                  ));
                            },
                          ),
                          Divider(
                              color: Colors.grey[300],
                              thickness: 2,
                              height: 30),
                          _buildProfileRow(
                            Icons.logout,
                            "Logout",
                            () {
                              box.delete("token");
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LogInPage(),
                                  ));
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 120,
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

  Widget _buildTopIcon(IconData icon, String label, void Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 28,
              color: Colors.black87,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileRow(IconData icon, String title, void Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 30, color: Colors.black54),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}
