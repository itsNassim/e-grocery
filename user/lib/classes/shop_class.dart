import 'package:user/classes/user_class.dart';

class ShopClass {
  final String imageUrl;
  final String name;
  final User owner;
  final String email;
  final String phone;
  final String address;
  final String opening_time;
  final String closing_time;

  ShopClass({
    required this.imageUrl,
    required this.name,
    required this.owner,
    required this.email,
    required this.phone,
    required this.address,
    required this.opening_time,
    required this.closing_time,
  });
}

List<ShopClass> globalShopsList = [
  ShopClass(
    imageUrl: 'assets/logo/FreshMart_Grocery.png',
    name: 'FreshMart Grocery',
    owner: globalUsersList[0],
    email: 'freshmart@example.com',
    phone: '+1234567890',
    address: '123 Main Street, Cityville',
    opening_time: '08:00',
    closing_time: '22:00',
  ),
  ShopClass(
    imageUrl: 'assets/logo/Daily_Needs.png',
    name: 'Daily Needs',
    owner: globalUsersList[1],
    email: 'dailyneeds@example.com',
    phone: '+0987654321',
    address: '456 Elm Avenue, Townsville',
    opening_time: '09:00',
    closing_time: '21:00',
  ),
  ShopClass(
    imageUrl: 'assets/logo/Green_Basket.png',
    name: 'Green Basket',
    owner: globalUsersList[2],
    email: 'greenbasket@example.com',
    phone: '+1122334455',
    address: '789 Oak Road, Villagetown',
    opening_time: '07:30',
    closing_time: '20:30',
  ),
];
