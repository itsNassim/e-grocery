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
    
    return Container(
      width: 260,
      color: isDarkMode ? const Color(0xFF0A0E21) : Colors.white,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Image.asset(
              'assets/images/logo.png',
              height: 100,
            ),
          ),
          // Profile Section
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed('/profile');
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage(shopkeeper.profileImageUrl),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          shopkeeper.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
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
                ],
              ),
            ),
          ),
          const Divider(),
          const SizedBox(height: 20),
          _buildNavItem(
            context: context,
            index: 0,
            title: 'Main',
            icon: Icons.home,
          ),
          _buildNavItem(
            context: context,
            index: 1,
            title: 'View all product',
            icon: Icons.shopping_bag,
          ),
          _buildNavItem(
            context: context,
            index: 2,
            title: 'View all order',
            icon: Icons.shopping_cart,
          ),
          _buildNavItem(
            context: context,
            index: 3,
            title: 'Profile',
            icon: Icons.person,
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Theme'),
            trailing: Switch(
              value: isDarkMode,
              onChanged: (_) {
                themeProvider.toggleTheme();
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required String title,
    required IconData icon,
  }) {
    final isSelected = selectedIndex == index;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected
            ? Theme.of(context).primaryColor
            : isDarkMode
                ? Colors.white
                : Colors.black54,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected
              ? Theme.of(context).primaryColor
              : isDarkMode
                  ? Colors.white
                  : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () => onItemSelected(index),
    );
  }
}