import 'package:flutter/material.dart';
import '../models/order.dart';
import 'package:intl/intl.dart';

class OrderItemWidget extends StatelessWidget {
  final Order order;

  const OrderItemWidget({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Define theme colors to match dashboard
    final primaryGreen = Color(0xFF2E7D32);
    final secondaryPurple = Color(0xFF6A1B9A);
    final bgColor = isDarkMode ? Color(0xFF1A2F1A) : Colors.white;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF1A2F1A) : Color(0xFFF5F8F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: primaryGreen.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryGreen.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              order.items.first.productImage,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${order.items.first.quantity}X For',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    Text(
                      '\$${order.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: primaryGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'By ${order.customerName}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: secondaryPurple,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: isDarkMode ? Colors.white60 : Colors.black45,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('MM/dd/yyyy').format(order.orderDate),
                      style: TextStyle(
                        color: isDarkMode ? Colors.white60 : Colors.black45,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}