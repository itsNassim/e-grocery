class Category {
  final String imageName;
  final String name;
  Category({
    required this.imageName,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      imageName: json['image'], 
      name: json['name'],
    );
  }

  
}

List<Category> GolbelCategoryList = [
  Category(imageName: "assets/icons/category_Icons/Meets.png", name: "Meets"),
  Category(
      imageName: "assets/icons/category_Icons/Vegetable.png",
      name: "Vegetable"),
  Category(imageName: "assets/icons/category_Icons/Fruits.png", name: "Fruits"),
  Category(imageName: "assets/icons/category_Icons/Breads.png", name: "Breads"),
  Category(imageName: "assets/icons/category_Icons/Snacks.png", name: "Snacks"),
  Category(imageName: "assets/icons/category_Icons/Bakery.png", name: "Bakery"),
  Category(imageName: "assets/icons/category_Icons/Dairy.png", name: "Dairy"),
  Category(imageName: "assets/icons/category_Icons/Sweet.png", name: "Sweet"),
  Category(
      imageName: "assets/icons/category_Icons/Chicken.png", name: "Chicken"),
];
