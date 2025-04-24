import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/order_provider.dart';
import '../models/order.dart';
import '../widgets/sidebar.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({Key? key}) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  // Constants for date and email to avoid issues
  final DateTime _defaultDate = DateTime.now();
  final String _defaultEmail = "customer@example.com";
  
  @override
  Widget build(BuildContext context) {
    final orderId = ModalRoute.of(context)!.settings.arguments as String;
    final orderProvider = Provider.of<OrderProvider>(context);
    final order = orderProvider.getOrderById(orderId);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Get screen dimensions for responsive layout
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final isMediumScreen = screenSize.width >= 600 && screenSize.width < 1200;
    final isLargeScreen = screenSize.width >= 1200;

    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            selectedIndex: 2, // Orders tab
            onItemSelected: (index) {
              if (index == 0) {
                Navigator.of(context).pushNamed('/dashboard');
              } else if (index == 1) {
                Navigator.of(context).pushNamed('/products');
              } else if (index == 2) {
                Navigator.of(context).pushNamed('/orders');
              } else if (index == 3) {
                Navigator.of(context).pushNamed('/profile');
              }
            },
          ),
          Expanded(
            child: order == null
                ? _buildOrderNotFound(context)
                : LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // App Bar
                            Container(
                              padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                              decoration: BoxDecoration(
                                color: isDarkMode ? const Color(0xFF1A1F38) : Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.arrow_back),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    tooltip: 'Back to Orders',
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      'Order #${order.id}',
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 20 : 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(order.status).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          _getStatusIcon(order.status),
                                          color: _getStatusColor(order.status),
                                          size: 16,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          order.status,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: _getStatusColor(order.status),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  PopupMenuButton<String>(
                                    icon: const Icon(Icons.more_vert),
                                    onSelected: (value) {
                                      if (value == 'print') {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Printing invoice for order #${order.id}...'),
                                            backgroundColor: Colors.blue,
                                          ),
                                        );
                                      } else if (value == 'email') {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Sending email to $_defaultEmail...'),
                                            backgroundColor: Colors.blue,
                                          ),
                                        );
                                      } else if (value.startsWith('status:')) {
                                        final status = value.split(':')[1];
                                        Provider.of<OrderProvider>(context, listen: false)
                                            .updateOrderStatus(order.id, status);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Order status updated to $status'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 'print',
                                        child: Row(
                                          children: [
                                            Icon(Icons.print),
                                            SizedBox(width: 8),
                                            Text('Print Invoice'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'email',
                                        child: Row(
                                          children: [
                                            Icon(Icons.email),
                                            SizedBox(width: 8),
                                            Text('Email Customer'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'status:Pending',
                                        child: Row(
                                          children: [
                                            Icon(Icons.pending, color: Colors.orange),
                                            SizedBox(width: 8),
                                            Text('Mark as Pending'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'status:Processing',
                                        child: Row(
                                          children: [
                                            Icon(Icons.sync, color: Colors.blue),
                                            SizedBox(width: 8),
                                            Text('Mark as Processing'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'status:Shipped',
                                        child: Row(
                                          children: [
                                            Icon(Icons.local_shipping, color: Colors.purple),
                                            SizedBox(width: 8),
                                            Text('Mark as Shipped'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'status:Delivered',
                                        child: Row(
                                          children: [
                                            Icon(Icons.check_circle, color: Colors.green),
                                            SizedBox(width: 8),
                                            Text('Mark as Delivered'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'status:Cancelled',
                                        child: Row(
                                          children: [
                                            Icon(Icons.cancel, color: Colors.red),
                                            SizedBox(width: 8),
                                            Text('Mark as Cancelled'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Order Details
                            Padding(
                              padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                              child: Flex(
                                direction: isSmallScreen ? Axis.vertical : Axis.horizontal,
                                crossAxisAlignment: isSmallScreen 
                                    ? CrossAxisAlignment.start 
                                    : CrossAxisAlignment.start,
                                children: [
                                  // Left Column
                                  Flexible(
                                    flex: isSmallScreen ? 0 : 1,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _buildDetailCard(
                                          context,
                                          'Order Information',
                                          [
                                            _buildDetailRow('Order ID', '#${order.id}'),
                                            _buildDetailRow('Date', DateFormat('MMM d, yyyy • h:mm a').format(_defaultDate)),
                                            _buildDetailRow('Status', order.status),
                                            _buildDetailRow('Payment Method', 'Credit Card'),
                                            _buildDetailRow('Payment Status', 'Paid'),
                                          ],
                                          isDarkMode,
                                        ),
                                        const SizedBox(height: 16),
                                        _buildDetailCard(
                                          context,
                                          'Customer Information',
                                          [
                                            _buildDetailRow('Name', order.customerName),
                                            _buildDetailRow('Email', _defaultEmail),
                                            _buildDetailRow('Phone', '+1 (555) 123-4567'),
                                          ],
                                          isDarkMode,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: isSmallScreen ? 0 : 16, height: isSmallScreen ? 16 : 0),
                                  // Right Column
                                  Flexible(
                                    flex: isSmallScreen ? 0 : 1,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _buildDetailCard(
                                          context,
                                          'Shipping Information',
                                          [
                                            _buildDetailRow('Address', '123 Main St'),
                                            _buildDetailRow('City', 'New York'),
                                            _buildDetailRow('State', 'NY'),
                                            _buildDetailRow('Zip Code', '10001'),
                                            _buildDetailRow('Country', 'United States'),
                                          ],
                                          isDarkMode,
                                        ),
                                        const SizedBox(height: 16),
                                        _buildDetailCard(
                                          context,
                                          'Shipping Method',
                                          [
                                            _buildDetailRow('Method', 'Standard Shipping'),
                                            _buildDetailRow('Tracking Number', 'TRK123456789'),
                                            _buildDetailRow('Estimated Delivery', DateFormat('MMM d, yyyy').format(_defaultDate.add(const Duration(days: 5)))),
                                          ],
                                          isDarkMode,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Order Items
                            Padding(
                              padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Order Items',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            minWidth: constraints.maxWidth - 64,
                                          ),
                                          child: DataTable(
                                            columnSpacing: 16,
                                            horizontalMargin: 0,
                                            columns: const [
                                              DataColumn(label: Text('Product')),
                                              DataColumn(label: Text('SKU')),
                                              DataColumn(label: Text('Price'), numeric: true),
                                              DataColumn(label: Text('Quantity'), numeric: true),
                                              DataColumn(label: Text('Total'), numeric: true),
                                            ],
                                            rows: order.items.map((item) {
                                              return DataRow(
                                                cells: [
                                                  DataCell(
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: 40,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                            color: Colors.grey.shade200,
                                                            borderRadius: BorderRadius.circular(4),
                                                          ),
                                                          child: const Center(
                                                            child: Icon(Icons.image, color: Colors.grey),
                                                          ),
                                                        ),
                                                        const SizedBox(width: 8),
                                                        Flexible(
                                                          child: Text(
                                                            item.name,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  DataCell(Text(item.sku)),
                                                  DataCell(Text('\$${item.price.toStringAsFixed(2)}')),
                                                  DataCell(Text('${item.quantity}')),
                                                  DataCell(
                                                    Text(
                                                      '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: SizedBox(
                                          width: isSmallScreen ? double.infinity : 300,
                                          child: Column(
                                            children: [
                                              _buildOrderSummaryRow('Subtotal', '\$${(order.totalAmount * 0.9).toStringAsFixed(2)}'),
                                              _buildOrderSummaryRow('Tax', '\$${(order.totalAmount * 0.1).toStringAsFixed(2)}'),
                                              _buildOrderSummaryRow('Shipping', 'Free'),
                                              const Divider(),
                                              _buildOrderSummaryRow(
                                                'Total',
                                                '\$${order.totalAmount.toStringAsFixed(2)}',
                                                isBold: true,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Order Timeline
                            Padding(
                              padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Order Timeline',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      _buildOrderTimeline(isDarkMode),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Order Notes
                            Padding(
                              padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Order Notes',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      TextField(
                                        maxLines: 3,
                                        decoration: InputDecoration(
                                          hintText: 'Add a note to this order...',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Note added successfully'),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          },
                                          child: const Text('Add Note'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderNotFound(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Order Not Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'The order you are looking for does not exist',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pushNamed('/orders');
            },
            icon: const Icon(Icons.arrow_back),
            label: const Text('Back to Orders'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(BuildContext context, String title, List<Widget> children, bool isDarkMode) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 16 : 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 16 : 14,
              color: isBold ? Colors.green : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTimeline(bool isDarkMode) {
    return Column(
      children: [
        _buildTimelineItem(
          'Order Placed',
          DateFormat('MMM d, yyyy • h:mm a').format(_defaultDate.subtract(const Duration(days: 2))),
          'Order #12345 was placed',
          isDarkMode,
          isCompleted: true,
        ),
        _buildTimelineItem(
          'Payment Confirmed',
          DateFormat('MMM d, yyyy • h:mm a').format(_defaultDate.subtract(const Duration(days: 2))),
          'Payment of \$156.00 was confirmed',
          isDarkMode,
          isCompleted: true,
        ),
        _buildTimelineItem(
          'Processing',
          DateFormat('MMM d, yyyy • h:mm a').format(_defaultDate.subtract(const Duration(days: 1))),
          'Order is being processed',
          isDarkMode,
          isCompleted: true,
        ),
        _buildTimelineItem(
          'Shipped',
          DateFormat('MMM d, yyyy • h:mm a').format(_defaultDate),
          'Order has been shipped via Standard Shipping',
          isDarkMode,
          isCompleted: true,
          isLast: false,
        ),
        _buildTimelineItem(
          'Delivered',
          'Estimated: ${DateFormat('MMM d, yyyy').format(_defaultDate.add(const Duration(days: 3)))}',
          'Pending delivery',
          isDarkMode,
          isCompleted: false,
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildTimelineItem(
    String title,
    String date,
    String description,
    bool isDarkMode, {
    bool isCompleted = false,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted ? Colors.green : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: isCompleted
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    )
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 50,
                color: isCompleted ? Colors.green : Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isCompleted ? Colors.green : Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                date,
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Processing':
        return Colors.blue;
      case 'Shipped':
        return Colors.purple;
      case 'Delivered':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Pending':
        return Icons.pending;
      case 'Processing':
        return Icons.sync;
      case 'Shipped':
        return Icons.local_shipping;
      case 'Delivered':
        return Icons.check_circle;
      case 'Cancelled':
        return Icons.cancel;
      default:
        return Icons.receipt_long;
    }
  }
}