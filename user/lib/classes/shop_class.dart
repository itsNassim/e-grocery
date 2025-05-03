import 'package:user/classes/user_class.dart';

class ShopClass {
  final int id;
  final String imageUrl;
  final String name;
  final User? owner;
  final String email;
  final String phone;
  final String address;
  final String openingTime;
  final String closingTime;

  ShopClass({
    required this.id,
    required this.imageUrl,
    required this.name,
    this.owner,
    required this.email,
    required this.phone,
    required this.address,
    required this.openingTime,
    required this.closingTime,
  });

  factory ShopClass.fromJson(Map<String, dynamic> json) {
    return ShopClass(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      openingTime: json['opening_time'],
      closingTime: json['closing_time'],
      imageUrl: json['image'], // Default to an empty string if null
      /*owner: json['owner'] != null
          ? User.fromJson(json['owner'])
          : null, */ // Assuming 'owner' is a nested User object
    );
  }

  // Optionally, you can define a method to convert the class into a JSON map for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'opening_time': openingTime,
      'closing_time': closingTime,
      'image': imageUrl,
      //'owner': owner?.toJson(), // Convert owner to JSON if it's not null
    };
  }
}

/*List<ShopClass> globalShopsList = [
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
*/
