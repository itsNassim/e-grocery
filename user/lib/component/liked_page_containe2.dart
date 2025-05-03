import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/blocs/liked_list_block.dart';
import 'package:user/classes/likesList_class.dart';
import 'package:user/classes/products_class.dart';
import 'package:user/component/liked_page_containe.dart';
import 'package:user/component/likes_page_products_tile.dart';
import 'package:user/component/likes_page_products_tile2.dart';

class LikedPageContaine2 extends StatelessWidget {
  final double height;
  final double width;
  final void Function(String name)? onCreate;
  final void Function(int index)? onAdd;

  const LikedPageContaine2({
    super.key,
    required this.height,
    required this.width,
    this.onCreate,
    this.onAdd,
  });

  void _showFullScreenBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return LikedPageContaine(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          suggestion: ["Meat", "Mouth watering", "Dinner"],
          onCreate: onCreate,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return ClipPath(
      clipper: CustomTopClipper(),
      child: Container(
        height: height * 0.5 + (keyboardHeight > 0 ? keyboardHeight : 0),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  _showFullScreenBottomSheet(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 30,
                      width: 30,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffFF6E57),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Create new list",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0D2826),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              BlocBuilder<LikeslistBloc, LikeslistState>(
                builder: (context, state) {
                  List<ProductsTile> productTiles =
                      state.likeslists.map((likeslist) {
                    return ProductsTile(
                      width: width,
                      item: likeslist,
                      onPressed: (p0) {},
                    );
                  }).toList();

                  return SizedBox(
                    height: height * 0.35 +
                        (keyboardHeight > 0 ? keyboardHeight : 0),
                    child: ListView.builder(
                      itemCount: productTiles.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            onAdd?.call(index);
                            Navigator.pop(context, true);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ProductsTile2(
                              item: productTiles[index].item,
                              width: width,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 40);
    path.quadraticBezierTo(
      size.width / 2,
      0,
      size.width,
      40,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return false;
  }
}
