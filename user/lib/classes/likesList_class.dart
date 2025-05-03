import 'package:user/classes/products_class.dart';

class Likeslist {
  final int id;
  final String title;
  final List<Product> productsList;

  Likeslist({
    required this.id,
    required this.title,
    required this.productsList,
  });

  Likeslist copyWith({
    int? id,
    String? title,
    List<Product>? productsList,
  }) {
    return Likeslist(
      id: id ?? this.id,
      title: title ?? this.title,
      productsList: productsList ?? this.productsList,
    );
  }

  factory Likeslist.fromJson(Map<String, dynamic> json) {
    return Likeslist(
      id: json['id'],
      title: json['title'],
      productsList:
          (json['products'] as List).map((p) => Product.fromJson(p)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'products': productsList.map((p) => p.toJson()).toList(),
      };
}

List<Likeslist> golobalLikesList = [];
