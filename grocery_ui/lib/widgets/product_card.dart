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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Define theme colors to match dashboard
    final primaryGreen = Color(0xFF2E7D32);
    final secondaryPurple = Color(0xFF6A1B9A);
    final lightGreen = Color(0xFF4CAF50);
    
    return Card(
      elevation: 2,
      shadowColor: primaryGreen.withOpacity(0.3),
      color: isDarkMode ? Color(0xFF1A2F1A) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: primaryGreen.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            '/edit-product',
            arguments: product.id,
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Image.asset(
                    product.imageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                if (product.onSale)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: secondaryPurple,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'SALE',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: PopupMenuButton(
                      icon: Icon(
                        Icons.more_vert,
                        color: primaryGreen,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, color: primaryGreen, size: 18),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red, size: 18),
                              SizedBox(width: 8),
                              Text('Delete'),
                            ],
                          ),
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
                              title: Text(
                                'Are you sure?',
                                style: TextStyle(color: primaryGreen),
                              ),
                              content: Text(
                                'Do you want to remove this product?',
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  child: Text(
                                    'No',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Delete product
                                    Navigator.of(ctx).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryGreen,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Text('Yes'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
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
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: secondaryPurple,
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
                          fontSize: product.onSale ? 14 : 18,
                          decoration: product.onSale
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: product.onSale
                              ? Colors.grey
                              : primaryGreen,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: lightGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: lightGreen.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          '${product.weight}${product.measureUnit}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: lightGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDarkMode ? Colors.white : Colors.black87,
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