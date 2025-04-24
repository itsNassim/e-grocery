import 'package:flutter/material.dart';

class FirstBackGround extends StatelessWidget {
  final ScreenHeight;
  final Color color;
  FirstBackGround({
    super.key,
    required this.ScreenHeight,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipPath(
        clipper: CustomBottomClipper(),
        child: Container(
          color: color,
          height: ScreenHeight * 0.3,
        ),
      ),
    );
  }
}

class CustomBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    Offset curveStartPoint = Offset(0, size.height * 0.60);
    Offset curveEndPoint = Offset(size.width, size.height * 0.60);
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
