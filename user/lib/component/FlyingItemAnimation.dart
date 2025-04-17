import 'package:flutter/material.dart';

class FlyingItemAnimation extends StatefulWidget {
  final Offset startPosition;
  final Offset endPosition;
  final VoidCallback onCompleted;

  const FlyingItemAnimation({
    super.key,
    required this.startPosition,
    required this.endPosition,
    required this.onCompleted,
  });

  @override
  State<FlyingItemAnimation> createState() => _FlyingItemAnimationState();
}

class _FlyingItemAnimationState extends State<FlyingItemAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _position;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _position = Tween<Offset>(
      begin: widget.startPosition,
      end: widget.endPosition,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onCompleted();
        }
      });

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            final offset = _position.value;
            return Positioned(
              top: offset.dy,
              left: offset.dx,
              child: Image.asset(
                'assets/icons/beetroot.png',
                width: 40,
                height: 40,
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
