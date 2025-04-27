import 'package:flutter/material.dart';
import 'package:user/classes/likesList_class.dart';
import 'package:user/classes/products_class.dart';

class ProductsTile2 extends StatefulWidget {
  final double width;
  final Likeslist item;

  ProductsTile2({
    super.key,
    required this.width,
    required this.item,
  });

  @override
  State<ProductsTile2> createState() => eProductsTileState();
}

class eProductsTileState extends State<ProductsTile2> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Container(
        height: 150,
        width: widget.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[100],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[200],
                ),
                child: Center(
                  child: widget.item.productsList.length > 0
                      ? Image.asset(
                          widget.item.productsList[0].imageName,
                          height: 200,
                          width: widget.width * 0.28,
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item.title,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.shopping_bag,
                        color: Colors.black45,
                      ),
                      Text(
                        "${widget.item.productsList.length} item",
                        style: TextStyle(
                            color: Colors.black45, fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
