import 'package:flutter/material.dart';
import 'package:user/classes/shop_class.dart';

class StoreTile extends StatelessWidget {
  final ShopClass store;
  final String time;
  StoreTile({
    super.key,
    required this.store,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                "assets/background/striped-awning.jpg",
                height: 125,
                width: 300,
                fit: BoxFit.cover,
              ),
            ),
          ),
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
                child: Image.asset(
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store.name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.flash_on,
                        color: Colors.amber,
                      ),
                      Text(
                        "In " + time,
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
