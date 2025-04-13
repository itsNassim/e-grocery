import 'package:flutter/material.dart';

class ScrollListTile extends StatelessWidget {
  final String title;
  final String imageName;
  ScrollListTile({
    super.key,
    required this.title,
    required this.imageName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 100, // increased from 70
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35),
              color: Color.fromARGB(255, 250, 203, 144),
            ),
            child: Center(
              child: ClipRRect(
                child: Image.asset(
                  imageName,
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: 3),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
