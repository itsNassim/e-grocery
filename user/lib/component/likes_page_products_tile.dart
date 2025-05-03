import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:user/classes/likesList_class.dart';
import 'package:user/classes/products_class.dart';

class ProductsTile extends StatefulWidget {
  final Likeslist item;
  final double width;
  final void Function(BuildContext)? onPressed;

  ProductsTile({
    super.key,
    required this.width,
    required this.item,
    required this.onPressed,
  });

  @override
  State<ProductsTile> createState() => eProductsTileState();
}

class eProductsTileState extends State<ProductsTile> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: StretchMotion(),
        children: [
          SlidableAction(
            onPressed: widget.onPressed,
            icon: Icons.delete,
            backgroundColor: Colors.red,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(12.0),
              bottomRight: Radius.circular(12.0),
            ),
          ),
        ],
      ),
      child: Padding(
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
                        child: widget.item.productsList.length > 0
                            ? Image.network(
                                widget.item.productsList[0].imageName,
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
                        child: widget.item.productsList.length > 1
                            ? Image.network(
                                widget.item.productsList[1].imageName,
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
                            child: widget.item.productsList.length > 2
                                ? Image.network(
                                    widget.item.productsList[2].imageName,
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
                            child: widget.item.productsList.length > 3
                                ? Image.network(
                                    widget.item.productsList[3].imageName,
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
      ),
    );
  }
}
