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
    
    // Define theme colors
    final primaryGreen = const Color(0xFF2E7D32);
    final secondaryPurple = const Color(0xFF6A1B9A);
    final lightGreen = const Color(0xFF4CAF50);
    final lightPurple = const Color(0xFF9C27B0);
    final bgColor = isDarkMode ? const Color(0xFF0A1F0A) : Colors.white;
    final cardColor = isDarkMode ? const Color(0xFF1A2F1A) : Colors.white;
    
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
            child: Container(
              color: bgColor,
              child: order == null
                  ? _buildOrderNotFound(context, primaryGreen, secondaryPurple)
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
                                  color: cardColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryGreen.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                  border: Border(
                                    bottom: BorderSide(
                                      color: primaryGreen.withOpacity(0.1),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // Logo
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [primaryGreen, secondaryPurple],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: primaryGreen.withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Image.asset(
                                          'assets/images/logo.png',
                                          width: 24,
                                          height: 24,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    IconButton(
                                      icon: Icon(
                                        Icons.arrow_back,
                                        color: primaryGreen,
                                      ),
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
                                          color: primaryGreen,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(order.status, primaryGreen, secondaryPurple).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: _getStatusColor(order.status, primaryGreen, secondaryPurple).withOpacity(0.2),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            _getStatusIcon(order.status),
                                            color: _getStatusColor(order.status, primaryGreen, secondaryPurple),
                                            size: 16,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            order.status,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: _getStatusColor(order.status, primaryGreen, secondaryPurple),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    PopupMenuButton<String>(
                                      icon: Icon(
                                        Icons.more_vert,
                                        color: primaryGreen,
                                      ),
                                      onSelected: (value) {
                                        if (value == 'print') {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Printing invoice for order #${order.id}...'),
                                              backgroundColor: primaryGreen,
                                            ),
                                          );
                                        } else if (value == 'email') {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Sending email to $_defaultEmail...'),
                                              backgroundColor: primaryGreen,
                                            ),
                                          );
                                        } else if (value.startsWith('status:')) {
                                          final status = value.split(':')[1];
                                          Provider.of<OrderProvider>(context, listen: false)
                                              .updateOrderStatus(order.id, status);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Order status updated to $status'),
                                              backgroundColor: primaryGreen,
                                            ),
                                          );
                                        }
                                      },
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          value: 'print',
                                          child: Row(
                                            children: [
                                              Icon(Icons.print, color: primaryGreen),
                                              const SizedBox(width: 8),
                                              const Text('Print Invoice'),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 'email',
                                          child: Row(
                                            children: [
                                              Icon(Icons.email, color: secondaryPurple),
                                              const SizedBox(width: 8),
                                              const Text('Email Customer'),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 'status:Pending',
                                          child: Row(
                                            children: [
                                              const Icon(Icons.pending, color: Colors.orange),
                                              const SizedBox(width: 8),
                                              const Text('Mark as Pending'),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 'status:Processing',
                                          child: Row(
                                            children: [
                                              Icon(Icons.sync, color: secondaryPurple),
                                              const SizedBox(width: 8),
                                              const Text('Mark as Processing'),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 'status:Shipped',
                                          child: Row(
                                            children: [
                                              const Icon(Icons.local_shipping, color: Colors.purple),
                                              const SizedBox(width: 8),
                                              const Text('Mark as Shipped'),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 'status:Delivered',
                                          child: Row(
                                            children: [
                                              Icon(Icons.check_circle, color: primaryGreen),
                                              const SizedBox(width: 8),
                                              const Text('Mark as Delivered'),
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
                                              _buildDetailRow('Order ID', '#${order.id}', primaryGreen),
                                              _buildDetailRow('Date', DateFormat('MMM d, yyyy • h:mm a').format(_defaultDate), primaryGreen),
                                              _buildDetailRow('Status', order.status, _getStatusColor(order.status, primaryGreen, secondaryPurple)),
                                              _buildDetailRow('Payment Method', 'Credit Card', primaryGreen),
                                              _buildDetailRow('Payment Status', 'Paid', primaryGreen),
                                            ],
                                            isDarkMode,
                                            primaryGreen,
                                            cardColor,
                                          ),
                                          const SizedBox(height: 16),
                                          _buildDetailCard(
                                            context,
                                            'Customer Information',
                                            [
                                              _buildDetailRow('Name', order.customerName, primaryGreen),
                                              _buildDetailRow('Email', _defaultEmail, primaryGreen),
                                              _buildDetailRow('Phone', '+1 (555) 123-4567', primaryGreen),
                                            ],
                                            isDarkMode,
                                            secondaryPurple,
                                            cardColor,
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
                                              _buildDetailRow('Address', '123 Main St', primaryGreen),
                                              _buildDetailRow('City', 'New York', primaryGreen),
                                              _buildDetailRow('State', 'NY', primaryGreen),
                                              _buildDetailRow('Zip Code', '10001', primaryGreen),
                                              _buildDetailRow('Country', 'United States', primaryGreen),
                                            ],
                                            isDarkMode,
                                            primaryGreen,
                                            cardColor,
                                          ),
                                          const SizedBox(height: 16),
                                          _buildDetailCard(
                                            context,
                                            'Shipping Method',
                                            [
                                              _buildDetailRow('Method', 'Standard Shipping', primaryGreen),
                                              _buildDetailRow('Tracking Number', 'TRK123456789', primaryGreen),
                                              _buildDetailRow('Estimated Delivery', DateFormat('MMM d, yyyy').format(_defaultDate.add(const Duration(days: 5))), primaryGreen),
                                            ],
                                            isDarkMode,
                                            secondaryPurple,
                                            cardColor,
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
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: cardColor,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: primaryGreen.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: primaryGreen.withOpacity(0.1),
                                      width: 1,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Order Items',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: primaryGreen,
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
                                              headingRowColor: MaterialStateProperty.all(
                                                primaryGreen.withOpacity(0.1),
                                              ),
                                              border: TableBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                horizontalInside: BorderSide(
                                                  color: primaryGreen.withOpacity(0.1),
                                                  width: 1,
                                                ),
                                              ),
                                              columns: [
                                                DataColumn(
                                                  label: Text(
                                                    'Product',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: primaryGreen,
                                                    ),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'SKU',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: primaryGreen,
                                                    ),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Price',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: primaryGreen,
                                                    ),
                                                  ),
                                                  numeric: true,
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Quantity',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: primaryGreen,
                                                    ),
                                                  ),
                                                  numeric: true,
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Total',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: primaryGreen,
                                                    ),
                                                  ),
                                                  numeric: true,
                                                ),
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
                                                              color: primaryGreen.withOpacity(0.1),
                                                              borderRadius: BorderRadius.circular(4),
                                                              border: Border.all(
                                                                color: primaryGreen.withOpacity(0.2),
                                                                width: 1,
                                                              ),
                                                            ),
                                                            child: Center(
                                                              child: Icon(
                                                                Icons.image,
                                                                color: primaryGreen,
                                                                size: 20,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(width: 8),
                                                          Flexible(
                                                            child: Text(
                                                              item.name,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                color: isDarkMode ? Colors.white : Colors.black87,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Text(
                                                        item.sku,
                                                        style: TextStyle(
                                                          color: secondaryPurple,
                                                        ),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Text(
                                                        '\$${item.price.toStringAsFixed(2)}',
                                                        style: TextStyle(
                                                          color: primaryGreen,
                                                        ),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Text(
                                                        '${item.quantity}',
                                                        style: TextStyle(
                                                          color: isDarkMode ? Colors.white : Colors.black87,
                                                        ),
                                                      ),
                                                    ),
                                                    DataCell(
                                                      Text(
                                                        '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: primaryGreen,
                                                        ),
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
                                          child: Container(
                                            width: isSmallScreen ? double.infinity : 300,
                                            padding: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: primaryGreen.withOpacity(0.05),
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(
                                                color: primaryGreen.withOpacity(0.1),
                                                width: 1,
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                _buildOrderSummaryRow('Subtotal', '\$${(order.totalAmount * 0.9).toStringAsFixed(2)}', primaryGreen),
                                                _buildOrderSummaryRow('Tax', '\$${(order.totalAmount * 0.1).toStringAsFixed(2)}', primaryGreen),
                                                _buildOrderSummaryRow('Shipping', 'Free', primaryGreen),
                                                Divider(
                                                  color: primaryGreen.withOpacity(0.2),
                                                  thickness: 1,
                                                ),
                                                _buildOrderSummaryRow(
                                                  'Total',
                                                  '\$${order.totalAmount.toStringAsFixed(2)}',
                                                  primaryGreen,
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
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: cardColor,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: primaryGreen.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: primaryGreen.withOpacity(0.1),
                                      width: 1,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Order Timeline',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: primaryGreen,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        _buildOrderTimeline(isDarkMode, primaryGreen, secondaryPurple),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // Order Notes
                              Padding(
                                padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: cardColor,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: primaryGreen.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: primaryGreen.withOpacity(0.1),
                                      width: 1,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Order Notes',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: primaryGreen,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        TextField(
                                          maxLines: 3,
                                          decoration: InputDecoration(
                                            hintText: 'Add a note to this order...',
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              borderSide: BorderSide(
                                                color: primaryGreen.withOpacity(0.2),
                                                width: 1,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              borderSide: BorderSide(
                                                color: primaryGreen.withOpacity(0.2),
                                                width: 1,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              borderSide: BorderSide(
                                                color: primaryGreen,
                                                width: 1,
                                              ),
                                            ),
                                            filled: true,
                                            fillColor: isDarkMode ? Colors.black12 : Colors.white,
                                          ),
                                          style: TextStyle(
                                            color: isDarkMode ? Colors.white : Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: const Text('Note added successfully'),
                                                  backgroundColor: primaryGreen,
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: primaryGreen,
                                              foregroundColor: Colors.white,
                                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              elevation: 0,
                                            ),
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
          ),
        ],
      ),
    );
  }

  Widget _buildOrderNotFound(BuildContext context, Color primaryGreen, Color secondaryPurple) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: secondaryPurple,
          ),
          const SizedBox(height: 16),
          Text(
            'Order Not Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primaryGreen,
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
              backgroundColor: primaryGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(
    BuildContext context, 
    String title, 
    List<Widget> children, 
    bool isDarkMode,
    Color titleColor,
    Color cardColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: titleColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: titleColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, Color valueColor) {
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
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummaryRow(String label, String value, Color valueColor, {bool isBold = false}) {
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
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTimeline(bool isDarkMode, Color primaryGreen, Color secondaryPurple) {
    return Column(
      children: [
        _buildTimelineItem(
          'Order Placed',
          DateFormat('MMM d, yyyy • h:mm a').format(_defaultDate.subtract(const Duration(days: 2))),
          'Order #12345 was placed',
          isDarkMode,
          primaryGreen,
          isCompleted: true,
        ),
        _buildTimelineItem(
          'Payment Confirmed',
          DateFormat('MMM d, yyyy • h:mm a').format(_defaultDate.subtract(const Duration(days: 2))),
          'Payment of \$156.00 was confirmed',
          isDarkMode,
          primaryGreen,
          isCompleted: true,
        ),
        _buildTimelineItem(
          'Processing',
          DateFormat('MMM d, yyyy • h:mm a').format(_defaultDate.subtract(const Duration(days: 1))),
          'Order is being processed',
          isDarkMode,
          primaryGreen,
          isCompleted: true,
        ),
        _buildTimelineItem(
          'Shipped',
          DateFormat('MMM d, yyyy • h:mm a').format(_defaultDate),
          'Order has been shipped via Standard Shipping',
          isDarkMode,
          primaryGreen,
          isCompleted: true,
          isLast: false,
        ),
        _buildTimelineItem(
          'Delivered',
          'Estimated: ${DateFormat('MMM d, yyyy').format(_defaultDate.add(const Duration(days: 3)))}',
          'Pending delivery',
          isDarkMode,
          primaryGreen,
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
    bool isDarkMode,
    Color primaryGreen, {
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
                color: isCompleted ? primaryGreen : Colors.grey.shade300,
                shape: BoxShape.circle,
                boxShadow: isCompleted ? [
                  BoxShadow(
                    color: primaryGreen.withOpacity(0.3),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ] : null,
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
                color: isCompleted ? primaryGreen : Colors.grey.shade300,
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
                  color: isCompleted ? primaryGreen : Colors.grey.shade600,
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

  Color _getStatusColor(String status, Color primaryGreen, Color secondaryPurple) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Processing':
        return secondaryPurple;
      case 'Shipped':
        return Colors.purple;
      case 'Delivered':
        return primaryGreen;
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
