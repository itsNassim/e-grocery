import 'package:flutter/material.dart';

class CurvedButton2 extends StatefulWidget {
  final double height;
  final double width;
  final void Function(int)? onQuantityChanged;

  const CurvedButton2({
    super.key,
    required this.height,
    required this.width,
    this.onQuantityChanged,
  });

  @override
  State<CurvedButton2> createState() => _CurvedButton2State();
}

class _CurvedButton2State extends State<CurvedButton2> {
  int quantity = 1;

  void _increase() {
    setState(() {
      quantity++;
    });
    widget.onQuantityChanged?.call(quantity);
  }

  void _decrease() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
      widget.onQuantityChanged?.call(quantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color activeColor = const Color(0xFF7D9A4F);

    return ClipPath(
      clipper: CustomClip(),
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          color: activeColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _iconButton("-", _decrease),
              Text(
                '$quantity',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _iconButton("+", _increase),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconButton(String text, void Function() onPressed) {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: 2,
          color: Colors.black,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: Center(
        child: TextButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
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
  bool shouldReclip(covariant CustomClipper oldClipper) => true;
}
