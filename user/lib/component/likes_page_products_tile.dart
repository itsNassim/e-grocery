import 'package:flutter/material.dart';
import 'package:user/classes/products_class.dart';

class ProductsTile extends StatefulWidget {
  double width;
  String Name;
  int counter;
  List<Product> productsList;

  ProductsTile({
    super.key,
    required this.width,
    required this.Name,
    required this.counter,
    required this.productsList,
  });

  @override
  State<ProductsTile> createState() => eProductsTileState();
}

class eProductsTileState extends State<ProductsTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Container(
        height: 300,
        width: widget.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.Name,
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
                    "${widget.counter} item",
                    style: TextStyle(
                        color: Colors.black45, fontWeight: FontWeight.w700),
                  )
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 200,
                    width: widget.width * 0.28,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[200],
                    ),
                    child: Center(
                      child: widget.productsList.length > 0
                          ? Image.asset(
                              widget.productsList[0].imageName,
                              height: 200,
                              width: widget.width * 0.28,
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Container(
                    height: 200,
                    width: widget.width * 0.28,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[200],
                    ),
                    child: Center(
                      child: widget.productsList.length > 1
                          ? Image.asset(
                              widget.productsList[1].imageName,
                              height: 200,
                              width: widget.width * 0.28,
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Column(
                    children: [
                      Container(
                        height: 96,
                        width: widget.width * 0.28,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[200],
                        ),
                        child: Center(
                          child: widget.productsList.length > 2
                              ? Image.asset(
                                  widget.productsList[2].imageName,
                                  height: 200,
                                  width: widget.width * 0.28,
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        height: 96,
                        width: widget.width * 0.28,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[200],
                        ),
                        child: Center(
                          child: widget.productsList.length > 3
                              ? Image.asset(
                                  widget.productsList[3].imageName,
                                  height: 200,
                                  width: widget.width * 0.28,
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
