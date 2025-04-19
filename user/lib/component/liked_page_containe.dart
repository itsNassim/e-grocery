import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class LikedPageContaine extends StatefulWidget {
  final double height;
  final double width;
  final List<String> suggestion;
  final void Function(String name)? onCreate;

  const LikedPageContaine({
    super.key,
    required this.height,
    required this.width,
    required this.suggestion,
    this.onCreate,
  });

  @override
  State<LikedPageContaine> createState() => _LikedPageContaineState();
}

class _LikedPageContaineState extends State<LikedPageContaine> {
  late TextEditingController _controller;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return ClipPath(
      clipper: CustomTopClipper(),
      child: Container(
        height: widget.height * 0.5 + (keyboardHeight > 0 ? keyboardHeight : 0),
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
              const Align(
                alignment: Alignment.center,
                child: Text(
                  "Create new list",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Give your list a name!',
                  hintStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black45,
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: Colors.black45, width: 2),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: Color(0xff51746C), width: 2),
                  ),
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () {
                            _controller.clear();
                            setState(() {
                              _selectedIndex = null;
                            });
                          },
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 30),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Suggestions : ",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.suggestion.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _controller.text = widget.suggestion[index];
                            _selectedIndex = index;
                          });
                        },
                        child: DottedBorder(
                          color: _selectedIndex == index
                              ? const Color(0xff51746C)
                              : Colors.black45,
                          strokeWidth: 1,
                          dashPattern: [10, 3],
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(8),
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              widget.suggestion[index],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _selectedIndex == index
                                    ? const Color(0xff51746C) // Selected color
                                    : Colors.black45, // Default color
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 50),
              GestureDetector(
                onTap: () {
                  if (_controller.text.isNotEmpty) {
                    widget.onCreate?.call(_controller.text);
                    Navigator.pop(context);
                    Navigator.pop(context, true);
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  width: widget.width - 25,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xffBBEA70),
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: const Center(
                    child: Text(
                      "Create new list",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff055222),
                      ),
                    ),
                  ),
                ),
              )
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
