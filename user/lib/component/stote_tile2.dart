import 'package:flutter/material.dart';
import 'package:user/classes/shop_class.dart';

class StoreTile2 extends StatefulWidget {
  final ShopClass store;
  final String price;
  final double rating;
  final bool isSelected;
  final double width;
  final void Function()? onTap;

  const StoreTile2({
    super.key,
    required this.store,
    required this.price,
    required this.rating,
    required this.isSelected,
    required this.width,
    required this.onTap,
  });

  @override
  State<StoreTile2> createState() => _StoreTile2State();
}

class _StoreTile2State extends State<StoreTile2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: widget.width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: widget.isSelected
            ? const Color(0xFF7D9A4F).withOpacity(0.3)
            : Colors.grey[300],
        border: widget.isSelected
            ? Border.all(width: 1, color: const Color(0xFF7D9A4F))
            : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(35),
            child: Image.network(
              widget.store.imageUrl,
              height: 70,
              width: 70,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 30),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.store.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                Row(
                  children: [
                    for (int i = 0; i < widget.rating.floor(); i++)
                      const Icon(Icons.star, color: Colors.amber, size: 22),
                    if (widget.rating - widget.rating.floor() >= 0.5)
                      const Icon(Icons.star_half,
                          color: Colors.amber, size: 22),
                    for (int i = 0; i < 5 - widget.rating.ceil(); i++)
                      const Icon(Icons.star_border,
                          color: Colors.grey, size: 22),
                  ],
                ),
                SizedBox(
                  height: 6,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${widget.price}\$",
                      style: const TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Row(
                        children: const [
                          Text(
                            "More details",
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
