import 'package:flutter/material.dart';
import '../models/shopkeeper.dart';
import 'dart:io';

class ShopkeeperProvider with ChangeNotifier {
  Shopkeeper _shopkeeper = Shopkeeper(
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

  Shopkeeper get shopkeeper => _shopkeeper;

  void updateShopkeeperInfo({
    String? name,
    String? email,
    String? phone,
    String? shopName,
    String? shopAddress,
    String? shopDescription,
  }) {
    _shopkeeper = _shopkeeper.copyWith(
      name: name,
      email: email,
      phone: phone,
      shopName: shopName,
      shopAddress: shopAddress,
      shopDescription: shopDescription,
    );
    notifyListeners();
  }

  void updateBusinessHours(List<BusinessHour> businessHours) {
    _shopkeeper = _shopkeeper.copyWith(businessHours: businessHours);
    notifyListeners();
  }

  void updatePaymentInfo(PaymentInfo paymentInfo) {
    _shopkeeper = _shopkeeper.copyWith(paymentInfo: paymentInfo);
    notifyListeners();
  }

  Future<void> updateProfileImage(File imageFile) async {
    // In a real app, you would upload the image to a server
    // and get back a URL. For this example, we'll just pretend
    // the image was uploaded successfully.
    _shopkeeper = _shopkeeper.copyWith(
      profileImageUrl: imageFile.path,
    );
    notifyListeners();
  }

  Future<bool> changePassword(String currentPassword, String newPassword) async {
    // In a real app, you would verify the current password
    // and update with the new password on your backend.
    // For this example, we'll just pretend it was successful.
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}