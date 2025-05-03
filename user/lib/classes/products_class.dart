import 'package:flutter/foundation.dart';
import 'package:user/classes/category_class.dart' as custom;
import 'package:user/classes/shop_class.dart';

class Product {
  final String id;
  final String imageName;
  final String name;
  final String baseSlug;
  final String price;
  final ShopClass shop;
  final String weight;
  final String description;
  final custom.Category category;

  const Product({
    required this.id,
    required this.imageName,
    required this.name,
    required this.baseSlug, // <-- NEW
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

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['name'],
      baseSlug: json['base_slug'],
      price: json['price'].toString(),
      weight: json['weight'].toString(),
      description: json['description'],
      imageName: json['image'],
      category: custom.Category.fromJson(json['category']),
      shop: ShopClass.fromJson(json['store']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
      };
}

custom.Category getCategoryByName(String name) {
  return custom.GolbelCategoryList.firstWhere((cat) => cat.name == name);
}

/*List<Product> globalProductsList = [
  Product(
    id: "001",
    imageName: "assets/products/beetroot.png",
    name: "Beetroot",
    baseSlug: "beetroot",
    price: "17.25",
    shop: globalShopsList[0],
    weight: "500",
    description: "Freshly harvested beetroot, rich in nutrients.",
    category: getCategoryByName("Vegetable"),
  ),
  Product(
    id: "011",
    imageName: "assets/products/beetroot.png",
    name: "Golden Beetroot",
    baseSlug: "beetroot",
    price: "18.20",
    shop: globalShopsList[1],
    weight: "500",
    description: "Golden variety of beetroot, rich in nutrients.",
    category: getCategoryByName("Vegetable"),
  ),
  Product(
    id: "012",
    imageName: "assets/products/beetroot.png",
    name: "Beetroot Milk",
    baseSlug: "beetroot milk",
    price: "18.20",
    shop: globalShopsList[2],
    weight: "500",
    description: "Beetroot-flavored milk, packed with nutrients.",
    category: getCategoryByName("Dairy"),
  ),
  Product(
    id: "002",
    imageName: "assets/products/tomato.png",
    name: "Tomato",
    baseSlug: "tomato",
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
    baseSlug: "carrot",
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
    baseSlug: "cucumber",
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
    baseSlug: "broccoli",
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
    baseSlug: "spinach",
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
    baseSlug: "apple",
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
    baseSlug: "banana",
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
    baseSlug: "orange",
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
    baseSlug: "lettuce",
    price: "7.25",
    shop: globalShopsList[0],
    weight: "400",
    description: "Crispy lettuce leaves for fresh salads.",
    category: getCategoryByName("Vegetable"),
  ),
];
*/