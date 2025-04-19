import 'package:flutter/foundation.dart';
import 'package:user/classes/category_class.dart' as custom;

class Product {
  final String imageName;
  final String name;
  final String price;
  final String shop;
  final String weight;
  final String description;
  final custom.Category category;

  const Product({
    required this.imageName,
    required this.name,
    required this.price,
    required this.shop,
    required this.weight,
    required this.description,
    required this.category,
  });
}

custom.Category getCategoryByName(String name) {
  return custom.GolbelCategoryList.firstWhere((cat) => cat.name == name);
}

List<Product> globalProductsList = [
  Product(
    imageName: "assets/products/beetroot.png",
    name: "Beetroot",
    price: "17.25",
    shop: "Local Shop",
    weight: "500",
    description: "Freshly harvested beetroot, rich in nutrients.",
    category: getCategoryByName("Vegetable"),
  ),
  Product(
    imageName: "assets/products/tomato.png",
    name: "Tomato",
    price: "12.50",
    shop: "Green Market",
    weight: "1000",
    description: "Juicy red tomatoes perfect for salads and cooking.",
    category: getCategoryByName("Vegetable"),
  ),
  Product(
    imageName: "assets/products/carrot.png",
    name: "Carrot",
    price: "9.00",
    shop: "Farm Fresh",
    weight: "750",
    description: "Crunchy and sweet carrots from organic farms.",
    category: getCategoryByName("Vegetable"),
  ),
  Product(
    imageName: "assets/products/cucumber.png",
    name: "Cucumber",
    price: "11.25",
    shop: "Daily Greens",
    weight: "600",
    description: "Cool and refreshing cucumbers for snacking.",
    category: getCategoryByName("Vegetable"),
  ),
  Product(
    imageName: "assets/products/broccoli.png",
    name: "Broccoli",
    price: "15.30",
    shop: "Local Shop",
    weight: "400",
    description: "Green, fresh broccoli loaded with vitamins.",
    category: getCategoryByName("Vegetable"),
  ),
  Product(
    imageName: "assets/products/spinach.png",
    name: "Spinach",
    price: "8.50",
    shop: "Farm Fresh",
    weight: "300",
    description: "Fresh spinach leaves perfect for smoothies or salads.",
    category: getCategoryByName("Vegetable"),
  ),
  Product(
    imageName: "assets/products/apple.png",
    name: "Apple",
    price: "22.00",
    shop: "Fruit Corner",
    weight: "500",
    description: "Crisp and sweet apples from the orchard.",
    category: getCategoryByName("Fruits"),
  ),
  Product(
    imageName: "assets/products/banana.png",
    name: "Banana",
    price: "10.00",
    shop: "Tropical Fruit",
    weight: "1000",
    description: "Ripe bananas full of energy and potassium.",
    category: getCategoryByName("Fruits"),
  ),
  Product(
    imageName: "assets/products/orange.png",
    name: "Orange",
    price: "18.75",
    shop: "Citrus World",
    weight: "800",
    description: "Zesty oranges packed with vitamin C.",
    category: getCategoryByName("Fruits"),
  ),
  Product(
    imageName: "assets/products/lettuce.png",
    name: "Lettuce",
    price: "7.25",
    shop: "Green Basket",
    weight: "400",
    description: "Crispy lettuce leaves for fresh salads.",
    category: getCategoryByName("Vegetable"),
  ),
];
