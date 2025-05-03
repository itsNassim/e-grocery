import 'package:flutter/material.dart';
import 'package:user/classes/category_class.dart';

class ScrollListTile extends StatelessWidget {
  final Category category;
  ScrollListTile({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 75,
      height: 100,
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
                child: Image.network(
                  category.imageName,
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: 3),
          Text(
            category.name,
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
