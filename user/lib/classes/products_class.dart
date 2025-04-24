import 'package:flutter/foundation.dart';
import 'package:user/classes/category_class.dart' as custom;
import 'package:user/classes/shop_class.dart';

class Product {
  final String id; // Add this
  final String imageName;
  final String name;
  final String price;
  final ShopClass shop;
  final String weight;
  final String description;
  final custom.Category category;

  const Product({
    required this.id, // And include in constructor
    required this.imageName,
    required this.name,
    required this.price,
    required this.shop,
    required this.weight,
    required this.description,
    required this.category,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

custom.Category getCategoryByName(String name) {
  return custom.GolbelCategoryList.firstWhere((cat) => cat.name == name);
}

List<Product> globalProductsList = [
  Product(
    id: "001",
    imageName: "assets/products/beetroot.png",
    name: "Beetroot",
    price: "17.25",
    shop: globalShopsList[0],
    weight: "500",
    description: "Freshly harvested beetroot, rich in nutrients.",
    category: getCategoryByName("Vegetable"),
  ),
  Product(
    id: "002",
    imageName: "assets/products/tomato.png",
    name: "Tomato",
    price: "12.50",
    shop: globalShopsList[1],
    weight: "1000",
    description: "Juicy red tomatoes perfect for salads and cooking.",
    category: getCategoryByName("Vegetable"),
  ),
  Product(
    id: "003",
    imageName: "assets/products/carrot.png",
    name: "Carrot",
    price: "9.00",
    shop: globalShopsList[2],
    weight: "750",
    description: "Crunchy and sweet carrots from organic farms.",
    category: getCategoryByName("Vegetable"),
  ),
  Product(
    id: "004",
    imageName: "assets/products/cucumber.png",
    name: "Cucumber",
    price: "11.25",
    shop: globalShopsList[0],
    weight: "600",
    description: "Cool and refreshing cucumbers for snacking.",
    category: getCategoryByName("Vegetable"),
  ),
  Product(
    id: "005",
    imageName: "assets/products/broccoli.png",
    name: "Broccoli",
    price: "15.30",
    shop: globalShopsList[1],
    weight: "400",
    description: "Green, fresh broccoli loaded with vitamins.",
    category: getCategoryByName("Vegetable"),
  ),
  Product(
    id: "006",
    imageName: "assets/products/spinach.png",
    name: "Spinach",
    price: "8.50",
    shop: globalShopsList[2],
    weight: "300",
    description: "Fresh spinach leaves perfect for smoothies or salads.",
    category: getCategoryByName("Vegetable"),
  ),
  Product(
    id: "007",
    imageName: "assets/products/apple.png",
    name: "Apple",
    price: "22.00",
    shop: globalShopsList[0],
    weight: "500",
    description: "Crisp and sweet apples from the orchard.",
    category: getCategoryByName("Fruits"),
  ),
  Product(
    id: "008",
    imageName: "assets/products/banana.png",
    name: "Banana",
    price: "10.00",
    shop: globalShopsList[1],
    weight: "1000",
    description: "Ripe bananas full of energy and potassium.",
    category: getCategoryByName("Fruits"),
  ),
  Product(
    id: "009",
    imageName: "assets/products/orange.png",
    name: "Orange",
    price: "18.75",
    shop: globalShopsList[2],
    weight: "800",
    description: "Zesty oranges packed with vitamin C.",
    category: getCategoryByName("Fruits"),
  ),
  Product(
    id: "010",
    imageName: "assets/products/lettuce.png",
    name: "Lettuce",
    price: "7.25",
    shop: globalShopsList[0],
    weight: "400",
    description: "Crispy lettuce leaves for fresh salads.",
    category: getCategoryByName("Vegetable"),
  ),
];
