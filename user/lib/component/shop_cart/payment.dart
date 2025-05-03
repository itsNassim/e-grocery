import 'package:flutter/material.dart';
import 'package:user/classes/order_class.dart';
import 'package:video_player/video_player.dart';

class PaymentPage extends StatefulWidget {
  final double total;
  final void Function(String selectedMethod) function;
  const PaymentPage({
    super.key,
    required this.total,
    required this.function,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selectedMethod = 'Delivery';
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoController();
  }

  void _initializeVideoController() {
    _controller = VideoPlayerController.asset(
      _selectedMethod == "Delivery"
          ? 'assets/videos/delivery.mp4'
          : 'assets/videos/pickup.mp4',
    )..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
      });

    _controller.addListener(() {
      if (_controller.value.position >= _controller.value.duration &&
          _controller.value.isInitialized &&
          !_controller.value.isPlaying) {
        setState(() {
          _isPlaying = false;
          _controller.seekTo(Duration.zero);
        });
        widget.function(_selectedMethod);
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (_isInitialized) {
      setState(() {
        _isPlaying = true;
        _controller.play();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return ClipPath(
      clipper: CustomTopClipper(),
      child: SingleChildScrollView(
        child: Container(
          height: height * 0.45,
          color: Colors.white,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Center(
                  child: Container(
                    width: 50,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey[500],
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Choose a delivery method",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildOptionCard("Delivery", Icons.local_shipping),
                    SizedBox(
                      width: 20,
                    ),
                    _buildOptionCard("Pickup", Icons.store),
                  ],
                ),
                SizedBox(height: _isPlaying ? 40 : 100),
                GestureDetector(
                  onTap: _handleTap,
                  child: TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 300),
                    tween: Tween<double>(
                        begin: _isPlaying ? 70 : 140,
                        end: _isPlaying ? 140 : 70),
                    builder: (context, size, child) {
                      return Container(
                        width: MediaQuery.of(context).size.width - 50,
                        height: size,
                        decoration: BoxDecoration(
                          color: Color(0xff055A40),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: _isPlaying
                              ? _isInitialized
                                  ? FittedBox(
                                      fit: BoxFit.cover,
                                      clipBehavior: Clip.hardEdge,
                                      child: SizedBox(
                                        width: _controller.value.size.width,
                                        height: _controller.value.size.height,
                                        child: VideoPlayer(_controller),
                                      ),
                                    )
                                  : const Center(
                                      child: CircularProgressIndicator())
                              : Center(
                                  child: Text(
                                    'Confirm ${widget.total.toStringAsFixed(2)} DA',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(String method, IconData icon) {
    bool isSelected = _selectedMethod == method;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedMethod = method;
            _isPlaying = false;
            _initializeVideoController();
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: isSelected ? Color(0xff055A40) : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                Icon(icon,
                    color: isSelected ? Colors.white : Color(0xff055A40),
                    size: 32),
                const SizedBox(width: 10),
                Text(
                  method,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Color(0xff055A40),
                    fontSize: 18,
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
  bool shouldReclip(covariant CustomClipper oldClipper) => false;
}
