import 'package:flutter/material.dart';
import 'package:user/component/curved_button.dart';

// ignore: must_be_immutable
class ItemTile1 extends StatelessWidget {
  final String imageName;
  final String name;
  final String shopName;
  final String weight;
  final String price;
  final bool active;
  void Function()? onTap;
  void Function()? onTapCurvedButton;

  ItemTile1({
    super.key,
    required this.imageName,
    required this.name,
    required this.shopName,
    required this.weight,
    required this.price,
    required this.active,
    required this.onTap,
    required this.onTapCurvedButton,
  });

  @override
  Widget build(BuildContext context) {
    List<String> parts = price.split(".");
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: ClipPath(
        clipper: CustomBottomClipper(),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          height: 300,
          width: 150,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    ClipRRect(
                      child: Image.asset(
                        imageName,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "(${shopName})",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "$weight g",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${parts[0]}.",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              (parts.length > 1 ? parts[1] : "00") + "\$",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                /// Prevent gesture from propagating up when button is pressed
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GestureDetector(
                    onTap: onTapCurvedButton,
                    behavior: HitTestBehavior.translucent,
                    child: SizedBox(
                      height: 60,
                      width: double.infinity,
                      child: CurvedButton(
                        height: 60,
                        width: 150,
                        icon: Icons.add,
                        color: const Color.fromARGB(255, 226, 239, 218),
                        active: active,
                        onTap: onTapCurvedButton,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    Offset curveStartPoint = Offset(0, size.height * 0.93);
    Offset curveEndPoint = Offset(size.width, size.height * 0.92);
    path.lineTo(curveStartPoint.dx, curveStartPoint.dy);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      curveEndPoint.dx,
      curveEndPoint.dy,
    );
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}
