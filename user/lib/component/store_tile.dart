import 'package:flutter/material.dart';
import 'package:user/classes/shop_class.dart';

class StoreTile extends StatelessWidget {
  final ShopClass store;
  final Widget widget;
  final double rating;

  const StoreTile({
    super.key,
    required this.store,
    required this.widget,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          // Store Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                "assets/background/striped-awning.jpg",
                height: 125,
                width: 300,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Dark overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 125,
              width: 300,
              color: Colors.grey.withOpacity(0.15),
            ),
          ),
          // Store Logo
          Positioned(
            top: 100,
            left: 50,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(25),
                color: Colors.white,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  store.imageUrl,
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          Positioned(
            top: 170,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            for (int i = 1; i <= 5; i++)
                              Icon(
                                i <= rating
                                    ? Icons.star
                                    : (i - rating <= 0.5
                                        ? Icons.star_half
                                        : Icons.star_border),
                                color: Colors.orange,
                                size: 18,
                              ),
                            const SizedBox(width: 4),
                            Text(
                              rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        widget,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
