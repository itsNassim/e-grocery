import 'package:flutter/material.dart';

class SecondBackGround extends StatelessWidget {
  final ScreenHeight;
  SecondBackGround({
    super.key,
    required this.ScreenHeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      child: ClipPath(
        clipper: CustomBottomClipper(),
        child: Container(
          color: theme.primaryColor,
          height: ScreenHeight * 0.15,
        ),
      ),
    );
  }
}

class CustomBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    Offset curveStartPoint = Offset(0, size.height);
    Offset curveEndPoint = Offset(size.width, size.height);
    path.lineTo(curveStartPoint.dx, curveStartPoint.dy);
    path.quadraticBezierTo(
      size.width / 2,
      size.height * 0.4,
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
