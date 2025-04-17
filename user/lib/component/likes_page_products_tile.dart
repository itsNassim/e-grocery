import 'package:flutter/material.dart';

class ProductsTile extends StatefulWidget {
  double width;
  String Name;
  int counter;
  String? imageName1;
  String? imageName2;
  String? imageName3;
  String? imageName4;
  ProductsTile({
    super.key,
    required this.width,
    required this.Name,
    required this.counter,
    this.imageName1,
    this.imageName2,
    this.imageName3,
    this.imageName4,
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
                      child: widget.imageName1 != null
                          ? Image.asset(
                              widget.imageName1!,
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
                      child: widget.imageName2 != null
                          ? Image.asset(
                              widget.imageName2!,
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
                          child: widget.imageName3 != null
                              ? Image.asset(
                                  widget.imageName3!,
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
                          child: widget.imageName4 != null
                              ? Image.asset(
                                  widget.imageName4!,
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
