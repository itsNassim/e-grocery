import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CurvedButton extends StatelessWidget {
  final double height;
  final double width;
  final IconData icon;
  final Color color;
  void Function()? onTap;

  CurvedButton({
    super.key,
    required this.height,
    required this.width,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CustomClip(),
      child: Container(
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(20)),
        height: height,
        width: width,
        child: GestureDetector(
          onTap: onTap,
          child: Center(
            child: Icon(icon),
          ),
        ),
      ),
    );
  }
}

class CustomClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, size.height * 0.15);

    path.quadraticBezierTo(
      size.width / 2,
      size.height / 3,
      size.width,
      size.height * 0.15,
    );

    path.lineTo(size.width, size.height * 0.8);

    path.quadraticBezierTo(
      size.width / 2,
      size.height * 0.95,
      0,
      size.height * 0.8,
    );

    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}
