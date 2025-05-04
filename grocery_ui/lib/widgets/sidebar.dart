import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/shopkeeper_provider.dart';

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const Sidebar({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final shopkeeperProvider = Provider.of<ShopkeeperProvider>(context);
    final shopkeeper = shopkeeperProvider.shopkeeper;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final primaryGreen = const Color(0xFF2E7D32);
    final secondaryPurple = const Color(0xFF6A1B9A);

    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF0A1F0A) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        gradient: isDarkMode
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0A1F0A), Color(0xFF1A2F1A)],
              )
            : null,
      ),
      child: SingleChildScrollView( // 🔥 Make scrollable
        child: Column(
          children: [
            // Logo Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [primaryGreen, secondaryPurple],
                ),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "SM",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: primaryGreen,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Shop Manager",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Profile Section
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed('/profile');
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? Colors.black.withOpacity(0.2)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: primaryGreen.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(
                    color: primaryGreen.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: secondaryPurple,
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage(shopkeeper.profileImageUrl),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            shopkeeper.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                          Text(
                            shopkeeper.shopName,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDarkMode ? Colors.white70 : Colors.black54,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: secondaryPurple,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Menu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "MENU",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white60 : Colors.black54,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 10),
            _buildNavItem(
              context: context,
              index: 0,
              title: 'Dashboard',
              icon: Icons.dashboard,
              primaryGreen: primaryGreen,
              secondaryPurple: secondaryPurple,
            ),
            _buildNavItem(
              context: context,
              index: 1,
              title: 'Products',
              icon: Icons.shopping_bag,
              primaryGreen: primaryGreen,
              secondaryPurple: secondaryPurple,
            ),
            _buildNavItem(
              context: context,
              index: 2,
              title: 'Orders',
              icon: Icons.shopping_cart,
              primaryGreen: primaryGreen,
              secondaryPurple: secondaryPurple,
            ),
            _buildNavItem(
              context: context,
              index: 3,
              title: 'Profile',
              icon: Icons.person,
              primaryGreen: primaryGreen,
              secondaryPurple: secondaryPurple,
            ),

            const Divider(height: 30),

            // Settings
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "SETTINGS",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white60 : Colors.black54,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 10),
            _buildSettingsItem(
              context: context,
              title: 'Theme',
              icon: Icons.dark_mode,
              trailing: Switch(
                value: isDarkMode,
                activeColor: secondaryPurple,
                activeTrackColor: secondaryPurple.withOpacity(0.5),
                onChanged: (_) {
                  themeProvider.toggleTheme();
                },
              ),
              primaryGreen: primaryGreen,
            ),
            _buildSettingsItem(
              context: context,
              title: 'Notifications',
              icon: Icons.notifications,
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: isDarkMode ? Colors.white70 : Colors.black54,
              ),
              onTap: () {},
              primaryGreen: primaryGreen,
            ),
            _buildSettingsItem(
              context: context,
              title: 'Help & Support',
              icon: Icons.help,
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: isDarkMode ? Colors.white70 : Colors.black54,
              ),
              onTap: () {},
              primaryGreen: primaryGreen,
            ),

            const SizedBox(height: 20), // replaces Spacer()

            // Logout
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                  minimumSize: const Size(double.infinity, 0),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required String title,
    required IconData icon,
    required Color primaryGreen,
    required Color secondaryPurple,
  }) {
    final isSelected = selectedIndex == index;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        gradient: isSelected
            ? LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [primaryGreen, secondaryPurple],
              )
            : null,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected
              ? Colors.white
              : isDarkMode
                  ? Colors.white70
                  : primaryGreen,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : isDarkMode
                    ? Colors.white
                    : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onTap: () => onItemSelected(index),
        selected: isSelected,
        selectedTileColor: Colors.transparent,
      ),
    );
  }

  Widget _buildSettingsItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Widget trailing,
    required Color primaryGreen,
    Function()? onTap,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      leading: Icon(
        icon,
        color: isDarkMode ? Colors.white70 : primaryGreen,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
