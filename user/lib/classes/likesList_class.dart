import 'package:user/classes/products_class.dart';

class Likeslist {
  final String title;
  final List<Product> productsList;

  Likeslist({
    required this.title,
    required this.productsList,
  });
}

List<Likeslist> golobalLikesList = [];
