import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import '../widgets/sidebar.dart';
import '../providers/shopkeeper_provider.dart';
import '../models/shopkeeper.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 3; // New index for profile in sidebar
  int _selectedTabIndex = 0;
  final _formKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _shopNameController;
  late TextEditingController _shopAddressController;
  late TextEditingController _shopDescriptionController;
  
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  File? _imageFile;
  bool _isLoading = false;
  bool _isPasswordChanging = false;
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current values
    final shopkeeper = Provider.of<ShopkeeperProvider>(context, listen: false).shopkeeper;
    _nameController = TextEditingController(text: shopkeeper.name);
    _emailController = TextEditingController(text: shopkeeper.email);
    _phoneController = TextEditingController(text: shopkeeper.phone);
    _shopNameController = TextEditingController(text: shopkeeper.shopName);
    _shopAddressController = TextEditingController(text: shopkeeper.shopAddress);
    _shopDescriptionController = TextEditingController(text: shopkeeper.shopDescription);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _shopNameController.dispose();
    _shopAddressController.dispose();
    _shopDescriptionController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.of(context).pushReplacementNamed('/');
    } else if (index == 1) {
      Navigator.of(context).pushReplacementNamed('/products');
    } else if (index == 2) {
      Navigator.of(context).pushReplacementNamed('/orders');
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  Future<void> _saveProfileInfo() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final shopkeeperProvider = Provider.of<ShopkeeperProvider>(context, listen: false);
      
      // Update profile info
      shopkeeperProvider.updateShopkeeperInfo(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        shopName: _shopNameController.text,
        shopAddress: _shopAddressController.text,
        shopDescription: _shopDescriptionController.text,
      );

      // Update profile image if selected
      if (_imageFile != null) {
        await shopkeeperProvider.updateProfileImage(_imageFile!);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: $error'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _changePassword() async {
    if (!_passwordFormKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isPasswordChanging = true;
    });

    try {
      final shopkeeperProvider = Provider.of<ShopkeeperProvider>(context, listen: false);
      final success = await shopkeeperProvider.changePassword(
        _currentPasswordController.text,
        _newPasswordController.text,
      );

      if (success) {
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password changed successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Current password is incorrect'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to change password: $error'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isPasswordChanging = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final shopkeeper = Provider.of<ShopkeeperProvider>(context).shopkeeper;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            selectedIndex: _selectedIndex,
            onItemSelected: _onItemSelected,
          ),
          Expanded(
            child: Column(
              children: [
                // App Bar
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? const Color(0xFF0A0E21)
                        : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Shopkeeper Profile',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // Profile Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? const Color(0xFF1A1F38)
                        : Colors.blue.shade50,
                  ),
                  child: Row(
                    children: [
                      // Profile Image
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: _imageFile != null
                                ? FileImage(_imageFile!) as ImageProvider
                                : AssetImage(shopkeeper.profileImageUrl),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isDarkMode
                                      ? const Color(0xFF1A1F38)
                                      : Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: InkWell(
                                onTap: _pickImage,
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 24),
                      // Profile Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              shopkeeper.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              shopkeeper.shopName,
                              style: TextStyle(
                                fontSize: 16,
                                color: isDarkMode
                                    ? Colors.white70
                                    : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.email,
                                  size: 16,
                                  color: isDarkMode
                                      ? Colors.white70
                                      : Colors.black54,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  shopkeeper.email,
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.white70
                                        : Colors.black54,
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Icon(
                                  Icons.phone,
                                  size: 16,
                                  color: isDarkMode
                                      ? Colors.white70
                                      : Colors.black54,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  shopkeeper.phone,
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.white70
                                        : Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Verification Badge
                      if (shopkeeper.isVerified)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.verified,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'Verified',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                // Tabs
                Container(
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? const Color(0xFF0A0E21)
                        : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      _buildTab(0, 'Profile Info'),
                      _buildTab(1, 'Business Hours'),
                      _buildTab(2, 'Payment Info'),
                      _buildTab(3, 'Security'),
                    ],
                  ),
                ),
                // Tab Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: [
                      _buildProfileInfoTab(shopkeeper, isDarkMode),
                      _buildBusinessHoursTab(shopkeeper, isDarkMode),
                      _buildPaymentInfoTab(shopkeeper, isDarkMode),
                      _buildSecurityTab(isDarkMode),
                    ][_selectedTabIndex],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(int index, String title) {
    final isSelected = _selectedTabIndex == index;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected
                ? Theme.of(context).primaryColor
                : isDarkMode
                    ? Colors.white70
                    : Colors.black54,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfoTab(Shopkeeper shopkeeper, bool isDarkMode) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Personal Information Section
          const Text(
            'Personal Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Full Name'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: isDarkMode
                            ? const Color(0xFF0A0E21)
                            : Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Email Address'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: isDarkMode
                            ? const Color(0xFF0A0E21)
                            : Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Phone Number'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: isDarkMode
                            ? const Color(0xFF0A0E21)
                            : Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          
          // Shop Information Section
          const Text(
            'Shop Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Shop Name'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _shopNameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: isDarkMode
                            ? const Color(0xFF0A0E21)
                            : Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your shop name';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Shop Address'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _shopAddressController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: isDarkMode
                            ? const Color(0xFF0A0E21)
                            : Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your shop address';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Shop Description'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _shopDescriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDarkMode
                      ? const Color(0xFF0A0E21)
                      : Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Member Since: '),
              Text(
                DateFormat('MMMM dd, yyyy').format(shopkeeper.joinDate),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 32),
          
          // Save Button
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _saveProfileInfo,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.save),
              label: const Text('Save Changes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessHoursTab(Shopkeeper shopkeeper, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Business Hours',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                // Save business hours logic
              },
              icon: const Icon(Icons.save),
              label: const Text('Save Changes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: isDarkMode
                ? const Color(0xFF1A1F38)
                : Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Table Header
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? const Color(0xFF0A0E21)
                      : Colors.grey.shade100,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      flex: 2,
                      child: Text(
                        'Day',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 2,
                      child: Text(
                        'Opening Time',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 2,
                      child: Text(
                        'Closing Time',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Text(
                        'Closed',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Business Hours List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: shopkeeper.businessHours.length,
                itemBuilder: (ctx, index) {
                  final businessHour = shopkeeper.businessHours[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isDarkMode
                              ? Colors.grey.shade800
                              : Colors.grey.shade200,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(businessHour.day),
                        ),
                        Expanded(
                          flex: 2,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: businessHour.openTime,
                              isDense: true,
                              items: [
                                '08:00 AM',
                                '09:00 AM',
                                '10:00 AM',
                                '11:00 AM',
                                '12:00 PM',
                              ].map((time) => DropdownMenuItem(
                                value: time,
                                child: Text(time),
                              )).toList(),
                              onChanged: businessHour.isClosed
                                  ? null
                                  : (value) {
                                      // Update opening time logic
                                    },
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: businessHour.closeTime,
                              isDense: true,
                              items: [
                                '05:00 PM',
                                '06:00 PM',
                                '07:00 PM',
                                '08:00 PM',
                                '09:00 PM',
                                '10:00 PM',
                              ].map((time) => DropdownMenuItem(
                                value: time,
                                child: Text(time),
                              )).toList(),
                              onChanged: businessHour.isClosed
                                  ? null
                                  : (value) {
                                      // Update closing time logic
                                    },
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Checkbox(
                            value: businessHour.isClosed,
                            onChanged: (value) {
                              // Update closed status logic
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Note: Business hours are displayed to customers on your shop profile.',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentInfoTab(Shopkeeper shopkeeper, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Payment Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                // Save payment info logic
              },
              icon: const Icon(Icons.save),
              label: const Text('Save Changes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDarkMode
                ? const Color(0xFF1A1F38)
                : Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Bank Name'),
                        const SizedBox(height: 8),
                        TextFormField(
                          initialValue: shopkeeper.paymentInfo.bankName,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: isDarkMode
                                ? const Color(0xFF0A0E21)
                                : Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Account Holder Name'),
                        const SizedBox(height: 8),
                        TextFormField(
                          initialValue: shopkeeper.paymentInfo.accountHolderName,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: isDarkMode
                                ? const Color(0xFF0A0E21)
                                : Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Account Number'),
                        const SizedBox(height: 8),
                        TextFormField(
                          initialValue: shopkeeper.paymentInfo.accountNumber,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: isDarkMode
                                ? const Color(0xFF0A0E21)
                                : Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Tax ID'),
                        const SizedBox(height: 8),
                        TextFormField(
                          initialValue: shopkeeper.paymentInfo.taxId,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: isDarkMode
                                ? const Color(0xFF0A0E21)
                                : Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Note: Your payment information is securely stored and used only for processing payouts.',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityTab(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Security Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDarkMode
                ? const Color(0xFF1A1F38)
                : Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Form(
            key: _passwordFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Change Password',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _currentPasswordController,
                  obscureText: _obscureCurrentPassword,
                  decoration: InputDecoration(
                    labelText: 'Current Password',
                    filled: true,
                    fillColor: isDarkMode
                        ? const Color(0xFF0A0E21)
                        : Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureCurrentPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureCurrentPassword = !_obscureCurrentPassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your current password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: _obscureNewPassword,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    filled: true,
                    fillColor: isDarkMode
                        ? const Color(0xFF0A0E21)
                        : Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureNewPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureNewPassword = !_obscureNewPassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a new password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirm New Password',
                    filled: true,
                    fillColor: isDarkMode
                        ? const Color(0xFF0A0E21)
                        : Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your new password';
                    }
                    if (value != _newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: _isPasswordChanging ? null : _changePassword,
                    icon: _isPasswordChanging
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.lock),
                    label: const Text('Change Password'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Two-Factor Authentication',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Switch(
                      value: false,
                      onChanged: (value) {
                        // Enable 2FA logic
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text('Enable Two-Factor Authentication'),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Protect your account with an extra layer of security. When 2FA is enabled, you\'ll need to provide a verification code in addition to your password when signing in.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}