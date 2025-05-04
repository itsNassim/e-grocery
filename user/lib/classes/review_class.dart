import 'package:user/classes/user_class.dart';

class Review {
  final int Id;
  final User user;
  final String text;
  final int rating;

  Review({
    required this.Id,
    required this.text,
    required this.rating,
    required this.user,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      Id: json['id'],
      user: User.fromJson(json['user']),
      text: json['text'],
      rating: json['rating'],
    );
  }
}
