import 'package:flutter/material.dart';
import '../models/product.dart';
import '../screens/edit_product_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF1A1F38)
          : const Color(0xFFEAECF0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            '/edit-product',
            arguments: product.id,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  child: Image.asset(
                    product.imageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: PopupMenuButton(
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.black,
                    ),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'edit') {
                        Navigator.of(context).pushNamed(
                          EditProductScreen.routeName,
                          arguments: product.id,
                        );
                      } else if (value == 'delete') {
                        // Show delete confirmation
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Are you sure?'),
                            content: const Text(
                              'Do you want to remove this product?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: const Text('No'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Delete product
                                  Navigator.of(ctx).pop();
                                },
                                child: const Text('Yes'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (product.onSale)
                        Text(
                          '\$${product.salePrice?.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      if (product.onSale)
                        const SizedBox(width: 8),
                      Text(
                        product.onSale
                            ? '\$${product.price.toStringAsFixed(2)}'
                            : '\$${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: product.onSale
                              ? FontWeight.normal
                              : FontWeight.bold,
                          fontSize: product.onSale ? 14 : 16,
                          decoration: product.onSale
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: product.onSale
                              ? Colors.grey
                              : Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${product.weight}${product.measureUnit}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}