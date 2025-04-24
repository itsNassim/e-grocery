import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/shopkeeper.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  Shopkeeper? _currentShopkeeper;
  
  bool get isAuthenticated => _isAuthenticated;
  Shopkeeper? get currentShopkeeper => _currentShopkeeper;

  AuthProvider() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    
    if (token != null) {
      // In a real app, you would validate the token with your backend
      _isAuthenticated = true;
      
      // For demo purposes, create a mock shopkeeper
      _currentShopkeeper = Shopkeeper(
        id: 'shop1',
        name: 'John Smith',
        email: 'john.smith@groceryshop.com',
        phone: '+1 (555) 123-4567',
        profileImageUrl: 'assets/images/profile.jpg',
        shopName: 'Fresh Grocery Market',
        shopAddress: '123 Main Street, Anytown, USA',
        shopDescription: 'We provide fresh and organic groceries directly from farms to your table. Established in 2010, we have been serving the community with quality products at affordable prices.',
        businessHours: [
          BusinessHour(day: 'Monday', openTime: '08:00 AM', closeTime: '08:00 PM'),
          BusinessHour(day: 'Tuesday', openTime: '08:00 AM', closeTime: '08:00 PM'),
          BusinessHour(day: 'Wednesday', openTime: '08:00 AM', closeTime: '08:00 PM'),
          BusinessHour(day: 'Thursday', openTime: '08:00 AM', closeTime: '08:00 PM'),
          BusinessHour(day: 'Friday', openTime: '08:00 AM', closeTime: '09:00 PM'),
          BusinessHour(day: 'Saturday', openTime: '09:00 AM', closeTime: '09:00 PM'),
          BusinessHour(day: 'Sunday', openTime: '10:00 AM', closeTime: '06:00 PM', isClosed: false),
        ],
        paymentInfo: PaymentInfo(
          bankName: 'National Bank',
          accountNumber: 'XXXX-XXXX-XXXX-1234',
          accountHolderName: 'John Smith',
          taxId: 'TAX-12345-US',
        ),
        isVerified: true,
        joinDate: DateTime(2020, 5, 15),
      );
      
      notifyListeners();
    }
  }

  Future<bool> signIn(String email, String password, bool rememberMe) async {
    // In a real app, you would authenticate with your backend
    // For demo purposes, we'll just check if the email and password match our mock data
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    if (email == 'admin@example.com' && password == 'password') {
      _isAuthenticated = true;
      
      // Create a mock shopkeeper
      _currentShopkeeper = Shopkeeper(
        id: 'shop1',
        name: 'John Smith',
        email: email,
        phone: '+1 (555) 123-4567',
        profileImageUrl: 'assets/images/profile.jpg',
        shopName: 'Fresh Grocery Market',
        shopAddress: '123 Main Street, Anytown, USA',
        shopDescription: 'We provide fresh and organic groceries directly from farms to your table. Established in 2010, we have been serving the community with quality products at affordable prices.',
        businessHours: [
          BusinessHour(day: 'Monday', openTime: '08:00 AM', closeTime: '08:00 PM'),
          BusinessHour(day: 'Tuesday', openTime: '08:00 AM', closeTime: '08:00 PM'),
          BusinessHour(day: 'Wednesday', openTime: '08:00 AM', closeTime: '08:00 PM'),
          BusinessHour(day: 'Thursday', openTime: '08:00 AM', closeTime: '08:00 PM'),
          BusinessHour(day: 'Friday', openTime: '08:00 AM', closeTime: '09:00 PM'),
          BusinessHour(day: 'Saturday', openTime: '09:00 AM', closeTime: '09:00 PM'),
          BusinessHour(day: 'Sunday', openTime: '10:00 AM', closeTime: '06:00 PM', isClosed: false),
        ],
        paymentInfo: PaymentInfo(
          bankName: 'National Bank',
          accountNumber: 'XXXX-XXXX-XXXX-1234',
          accountHolderName: 'John Smith',
          taxId: 'TAX-12345-US',
        ),
        isVerified: true,
        joinDate: DateTime(2020, 5, 15),
      );
      
      if (rememberMe) {
        // Save auth token to shared preferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('auth_token', 'mock_token');
      }
      
      notifyListeners();
      return true;
    }
    
    return false;
  }

  Future<bool> signInWithGoogle() async {
    // In a real app, you would implement Google Sign-In
    // For demo purposes, we'll just simulate a successful sign-in
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    _isAuthenticated = true;
    
    // Create a mock shopkeeper
    _currentShopkeeper = Shopkeeper(
      id: 'shop1',
      name: 'John Smith',
      email: 'john.smith@gmail.com',
      phone: '+1 (555) 123-4567',
      profileImageUrl: 'assets/images/profile.jpg',
      shopName: 'Fresh Grocery Market',
      shopAddress: '123 Main Street, Anytown, USA',
      shopDescription: 'We provide fresh and organic groceries directly from farms to your table. Established in 2010, we have been serving the community with quality products at affordable prices.',
      businessHours: [
        BusinessHour(day: 'Monday', openTime: '08:00 AM', closeTime: '08:00 PM'),
        BusinessHour(day: 'Tuesday', openTime: '08:00 AM', closeTime: '08:00 PM'),
        BusinessHour(day: 'Wednesday', openTime: '08:00 AM', closeTime: '08:00 PM'),
        BusinessHour(day: 'Thursday', openTime: '08:00 AM', closeTime: '08:00 PM'),
        BusinessHour(day: 'Friday', openTime: '08:00 AM', closeTime: '09:00 PM'),
        BusinessHour(day: 'Saturday', openTime: '09:00 AM', closeTime: '09:00 PM'),
        BusinessHour(day: 'Sunday', openTime: '10:00 AM', closeTime: '06:00 PM', isClosed: false),
      ],
      paymentInfo: PaymentInfo(
        bankName: 'National Bank',
        accountNumber: 'XXXX-XXXX-XXXX-1234',
        accountHolderName: 'John Smith',
        taxId: 'TAX-12345-US',
      ),
      isVerified: true,
      joinDate: DateTime(2020, 5, 15),
    );
    
    // Save auth token to shared preferences
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('auth_token', 'mock_google_token');
    
    notifyListeners();
    return true;
  }

  Future<bool> signUp({
    required String name,
    required String email,
    required String phone,
    required String shopName,
    required String shopAddress,
    required String password,
  }) async {
    // In a real app, you would register with your backend
    // For demo purposes, we'll just simulate a successful registration
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // For demo purposes, always return success
    return true;
  }

  Future<bool> resetPassword(String email) async {
    // In a real app, you would send a reset password email
    // For demo purposes, we'll just simulate a successful request
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // For demo purposes, always return success
    return true;
  }

  Future<void> signOut() async {
    _isAuthenticated = false;
    _currentShopkeeper = null;
    
    // Clear auth token from shared preferences
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('auth_token');
    
    notifyListeners();
  }
}