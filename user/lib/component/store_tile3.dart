import 'package:flutter/material.dart';
import 'package:user/classes/shop_class.dart';

class StoreTile3 extends StatelessWidget {
  final double height;
  final double width;
  final ShopClass store;
  final String rating;
  final Widget? child;

  StoreTile3({
    super.key,
    required this.height,
    required this.width,
    required this.store,
    required this.rating,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: height * 0.22,
          width: width - 40,
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Profile image
              ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: Image.network(
                  store.imageUrl,
                  height: 70,
                  width: 70,
                  fit: BoxFit.cover,
                ),
              ),

              SizedBox(width: 16),

              // Info section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      store.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    /*Row(
                      children: [
                        Icon(Icons.person_2_outlined,
                            size: 18, color: Colors.grey),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            store.owner!.fullName,
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[800]),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),*/
                    Row(
                      children: [
                        Icon(Icons.email_outlined,
                            size: 16, color: Colors.grey),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            store.email,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[800]),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.local_phone_outlined,
                            size: 16, color: Colors.grey),
                        SizedBox(width: 5),
                        Text(
                          store.phone,
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[800]),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.pin_drop_outlined,
                            size: 16, color: Colors.grey),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            store.address,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[800]),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.store_mall_directory_outlined,
                                size: 16, color: Colors.green),
                            SizedBox(width: 4),
                            Text(
                              store.openingTime,
                              style:
                                  TextStyle(fontSize: 13, color: Colors.green),
                            ),
                            SizedBox(width: 30),
                            Icon(Icons.lock_clock_outlined,
                                size: 16, color: Colors.red),
                            SizedBox(width: 4),
                            Text(
                              store.closingTime,
                              style: TextStyle(fontSize: 13, color: Colors.red),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.star, color: Colors.orange),
                            SizedBox(height: 3),
                            Text(
                              "$rating/5",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Favorite and Report Buttons
        Positioned(
          top: 30,
          right: 16,
          child: Column(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Icon(
                    Icons.flag_outlined,
                    size: 22,
                    color: Colors.deepOrange,
                  ),
                ),
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: child,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
