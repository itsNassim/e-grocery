import 'package:user/classes/user_class.dart';

class ReviewClass {
  final User user;
  final String text;
  final int stars;

  ReviewClass({
    required this.user,
    required this.text,
    required this.stars,
  });
}

List<ReviewClass> golbelReviewList = [
  ReviewClass(
    user: globalUsersList[0],
    text: "Great quality products!",
    stars: 5,
  ),
  ReviewClass(
    user: globalUsersList[1],
    text: "Good prices and fast delivery.",
    stars: 4,
  ),
  ReviewClass(
    user: globalUsersList[2],
    text: "Customer support was helpful.",
    stars: 2,
  ),
];
