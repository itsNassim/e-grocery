import 'package:flutter/material.dart';

class CurvedButton extends StatefulWidget {
  final double height;
  final double width;
  final IconData icon;
  final Color color;
  final bool active;
  final void Function()? onTap;

  const CurvedButton({
    super.key,
    required this.height,
    required this.width,
    required this.icon,
    required this.color,
    required this.active,
    this.onTap,
  });

  @override
  State<CurvedButton> createState() => _CurvedButtonState();
}

class _CurvedButtonState extends State<CurvedButton> {
  late bool isQuantitySelector;
  int quantity = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.active) {
      isQuantitySelector = false;
    } else {
      isQuantitySelector = true;
    }
  }

  void _toggleToQuantitySelector() {
    if (!isQuantitySelector) {
      setState(() {
        isQuantitySelector = true;
      });
      widget.onTap?.call();
    }
  }

  void _increase() {
    setState(() {
      quantity++;
    });
  }

  void _decrease() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    } else {
      setState(() {
        if (widget.active) {
          isQuantitySelector = false;
        }
        quantity = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color activeColor = const Color(0xFF7D9A4F);

    return GestureDetector(
      onTap: widget.active ? _toggleToQuantitySelector : null,
      child: ClipPath(
        clipper: CustomClip(),
        child: Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            color: isQuantitySelector ? activeColor : widget.color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: isQuantitySelector
              ? Padding(
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
                )
              : Center(
                  child: Icon(widget.icon),
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
            style: TextStyle(
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
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return true;
  }
}
