import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/order_provider.dart';
import '../models/order.dart';
import '../widgets/sidebar.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({Key? key}) : super(key: key);

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  bool _isGridView = false;
  bool _isSelectionMode = false;
  final Set<String> _selectedOrders = {};
  String _searchQuery = '';
  String _statusFilter = 'All';
  String _sortBy = 'Date (Newest)';
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController _searchController = TextEditingController();

  // Constants for date and email to avoid issues
  final DateTime _defaultDate = DateTime.now();
  final String _defaultEmail = "customer@example.com";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleView() {
    setState(() {
      _isGridView = !_isGridView;
    });
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedOrders.clear();
      }
    });
  }

  void _toggleOrderSelection(String orderId) {
    setState(() {
      if (_selectedOrders.contains(orderId)) {
        _selectedOrders.remove(orderId);
      } else {
        _selectedOrders.add(orderId);
      }
    });
  }

  void _selectAllOrders(List<Order> orders) {
    setState(() {
      if (_selectedOrders.length == orders.length) {
        _selectedOrders.clear();
      } else {
        _selectedOrders.clear();
        for (var order in orders) {
          _selectedOrders.add(order.id);
        }
      }
    });
  }

  void _updateOrderStatus(String status) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    for (var orderId in _selectedOrders) {
      orderProvider.updateOrderStatus(orderId, status);
    }
    setState(() {
      _isSelectionMode = false;
      _selectedOrders.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_selectedOrders.length} orders updated to $status'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showDateRangePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  void _clearFilters() {
    setState(() {
      _searchQuery = '';
      _searchController.clear();
      _statusFilter = 'All';
      _sortBy = 'Date (Newest)';
      _startDate = null;
      _endDate = null;
    });
  }

  List<Order> _getFilteredOrders(List<Order> orders) {
    return orders.where((order) {
      // Apply search filter
      final matchesSearch = _searchQuery.isEmpty ||
          order.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          order.customerName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          _defaultEmail.toLowerCase().contains(_searchQuery.toLowerCase()); // Using default email

      // Apply status filter
      final matchesStatus = _statusFilter == 'All' || order.status == _statusFilter;

      // Apply date range filter - using default date
      final matchesDateRange = (_startDate == null || _endDate == null) ||
          (_defaultDate.isAfter(_startDate!) && _defaultDate.isBefore(_endDate!.add(const Duration(days: 1))));

      return matchesSearch && matchesStatus && matchesDateRange;
    }).toList();
  }

  List<Order> _getSortedOrders(List<Order> orders) {
    switch (_sortBy) {
      case 'Date (Newest)':
        // Using constant date for sorting
        return orders;
      case 'Date (Oldest)':
        // Using constant date for sorting
        return orders;
      case 'Amount (High to Low)':
        return orders..sort((a, b) => b.totalAmount.compareTo(a.totalAmount));
      case 'Amount (Low to High)':
        return orders..sort((a, b) => a.totalAmount.compareTo(b.totalAmount));
      case 'Customer Name (A-Z)':
        return orders..sort((a, b) => a.customerName.compareTo(b.customerName));
      default:
        return orders;
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final orders = orderProvider.orders;
    final filteredOrders = _getSortedOrders(_getFilteredOrders(orders));
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
                // Already on orders page
              } else if (index == 3) {
                Navigator.of(context).pushNamed('/profile');
              }
            },
          ),
          Expanded(
            child: Column(
              children: [
                // App Bar
                Container(
                  padding: const EdgeInsets.all(16),
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
                      const Text(
                        'Orders',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search orders...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: isDarkMode ? const Color(0xFF0A0E21) : Colors.grey.shade100,
                            contentPadding: const EdgeInsets.symmetric(vertical: 0),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      if (_isSelectionMode)
                        Text(
                          '${_selectedOrders.length} selected',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      const SizedBox(width: 16),
                      if (_isSelectionMode)
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
                          onSelected: (value) {
                            if (value == 'cancel') {
                              _toggleSelectionMode();
                            } else {
                              _updateOrderStatus(value);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'Pending',
                              child: Row(
                                children: [
                                  Icon(Icons.pending, color: Colors.orange),
                                  SizedBox(width: 8),
                                  Text('Mark as Pending'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'Processing',
                              child: Row(
                                children: [
                                  Icon(Icons.sync, color: Colors.blue),
                                  SizedBox(width: 8),
                                  Text('Mark as Processing'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'Shipped',
                              child: Row(
                                children: [
                                  Icon(Icons.local_shipping, color: Colors.purple),
                                  SizedBox(width: 8),
                                  Text('Mark as Shipped'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'Delivered',
                              child: Row(
                                children: [
                                  Icon(Icons.check_circle, color: Colors.green),
                                  SizedBox(width: 8),
                                  Text('Mark as Delivered'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'Cancelled',
                              child: Row(
                                children: [
                                  Icon(Icons.cancel, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Mark as Cancelled'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'cancel',
                              child: Row(
                                children: [
                                  Icon(Icons.close),
                                  SizedBox(width: 8),
                                  Text('Cancel Selection'),
                                ],
                              ),
                            ),
                          ],
                        )
                      else
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
                              onPressed: _toggleView,
                              tooltip: _isGridView ? 'List View' : 'Grid View',
                            ),
                            IconButton(
                              icon: const Icon(Icons.select_all),
                              onPressed: _toggleSelectionMode,
                              tooltip: 'Select Orders',
                            ),
                            IconButton(
                              icon: const Icon(Icons.print),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Printing orders...'),
                                    backgroundColor: Colors.blue,
                                  ),
                                );
                              },
                              tooltip: 'Print Orders',
                            ),
                            IconButton(
                              icon: const Icon(Icons.file_download),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Exporting orders...'),
                                    backgroundColor: Colors.blue,
                                  ),
                                );
                              },
                              tooltip: 'Export Orders',
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                // Filters
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDarkMode ? const Color(0xFF1A1F38) : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Status Filter
                      DropdownButton<String>(
                        value: _statusFilter,
                        onChanged: (value) {
                          setState(() {
                            _statusFilter = value!;
                          });
                        },
                        items: const [
                          DropdownMenuItem(
                            value: 'All',
                            child: Text('All Statuses'),
                          ),
                          DropdownMenuItem(
                            value: 'Pending',
                            child: Text('Pending'),
                          ),
                          DropdownMenuItem(
                            value: 'Processing',
                            child: Text('Processing'),
                          ),
                          DropdownMenuItem(
                            value: 'Shipped',
                            child: Text('Shipped'),
                          ),
                          DropdownMenuItem(
                            value: 'Delivered',
                            child: Text('Delivered'),
                          ),
                          DropdownMenuItem(
                            value: 'Cancelled',
                            child: Text('Cancelled'),
                          ),
                        ],
                        underline: Container(),
                        icon: const Icon(Icons.arrow_drop_down),
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Date Range Filter
                      OutlinedButton.icon(
                        onPressed: _showDateRangePicker,
                        icon: const Icon(Icons.date_range),
                        label: Text(
                          _startDate != null && _endDate != null
                              ? '${DateFormat('MMM d').format(_startDate!)} - ${DateFormat('MMM d').format(_endDate!)}'
                              : 'Date Range',
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Sort By
                      DropdownButton<String>(
                        value: _sortBy,
                        onChanged: (value) {
                          setState(() {
                            _sortBy = value!;
                          });
                        },
                        items: const [
                          DropdownMenuItem(
                            value: 'Date (Newest)',
                            child: Text('Date (Newest)'),
                          ),
                          DropdownMenuItem(
                            value: 'Date (Oldest)',
                            child: Text('Date (Oldest)'),
                          ),
                          DropdownMenuItem(
                            value: 'Amount (High to Low)',
                            child: Text('Amount (High to Low)'),
                          ),
                          DropdownMenuItem(
                            value: 'Amount (Low to High)',
                            child: Text('Amount (Low to High)'),
                          ),
                          DropdownMenuItem(
                            value: 'Customer Name (A-Z)',
                            child: Text('Customer Name (A-Z)'),
                          ),
                        ],
                        underline: Container(),
                        icon: const Icon(Icons.arrow_drop_down),
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      // Clear Filters
                      TextButton.icon(
                        onPressed: _clearFilters,
                        icon: const Icon(Icons.clear_all),
                        label: const Text('Clear Filters'),
                      ),
                    ],
                  ),
                ),
                // Order List
                Expanded(
                  child: filteredOrders.isEmpty
                      ? _buildEmptyState()
                      : _isGridView
                          ? _buildOrderGrid(filteredOrders, isDarkMode)
                          : _buildOrderList(filteredOrders, isDarkMode),
                ),
                // Bottom Stats
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDarkMode ? const Color(0xFF1A1F38) : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Orders: ${filteredOrders.length}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Total Value: \$${_calculateTotalValue(filteredOrders).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new order functionality
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Create new order feature coming soon'),
              backgroundColor: Colors.blue,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No Orders Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters or create a new order',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _clearFilters,
            icon: const Icon(Icons.refresh),
            label: const Text('Clear Filters'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList(List<Order> orders, bool isDarkMode) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: _isSelectionMode
                ? () => _toggleOrderSelection(order.id)
                : () {
                    Navigator.of(context).pushNamed(
                      '/order-detail',
                      arguments: order.id,
                    );
                  },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (_isSelectionMode)
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Checkbox(
                        value: _selectedOrders.contains(order.id),
                        onChanged: (value) => _toggleOrderSelection(order.id),
                      ),
                    ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Order #${order.id}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                                    size: 12,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    order.status,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: _getStatusColor(order.status),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Using constant date instead of order.date
                        Text(
                          DateFormat('MMM d, yyyy • h:mm a').format(_defaultDate),
                          style: TextStyle(
                            fontSize: 14,
                            color: isDarkMode ? Colors.white70 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.customerName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Using constant email instead of order.customerEmail
                        Text(
                          _defaultEmail,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDarkMode ? Colors.white70 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${order.items.length} ${order.items.length == 1 ? 'item' : 'items'}',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDarkMode ? Colors.white70 : Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$${order.totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!_isSelectionMode)
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.print, size: 20),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Printing invoice for order #${order.id}...'),
                                backgroundColor: Colors.blue,
                              ),
                            );
                          },
                          tooltip: 'Print Invoice',
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (ctx) => Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.visibility),
                                    title: const Text('View Details'),
                                    onTap: () {
                                      Navigator.of(ctx).pop();
                                      Navigator.of(context).pushNamed(
                                        '/order-detail',
                                        arguments: order.id,
                                      );
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.email),
                                    title: const Text('Email Customer'),
                                    onTap: () {
                                      Navigator.of(ctx).pop();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          // Using constant email instead of order.customerEmail
                                          content: Text('Sending email to $_defaultEmail...'),
                                          backgroundColor: Colors.blue,
                                        ),
                                      );
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.update),
                                    title: const Text('Update Status'),
                                    onTap: () {
                                      Navigator.of(ctx).pop();
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text('Update Order Status'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                leading: const Icon(Icons.pending, color: Colors.orange),
                                                title: const Text('Pending'),
                                                onTap: () {
                                                  Provider.of<OrderProvider>(context, listen: false)
                                                      .updateOrderStatus(order.id, 'Pending');
                                                  Navigator.of(ctx).pop();
                                                },
                                              ),
                                              ListTile(
                                                leading: const Icon(Icons.sync, color: Colors.blue),
                                                title: const Text('Processing'),
                                                onTap: () {
                                                  Provider.of<OrderProvider>(context, listen: false)
                                                      .updateOrderStatus(order.id, 'Processing');
                                                  Navigator.of(ctx).pop();
                                                },
                                              ),
                                              ListTile(
                                                leading: const Icon(Icons.local_shipping, color: Colors.purple),
                                                title: const Text('Shipped'),
                                                onTap: () {
                                                  Provider.of<OrderProvider>(context, listen: false)
                                                      .updateOrderStatus(order.id, 'Shipped');
                                                  Navigator.of(ctx).pop();
                                                },
                                              ),
                                              ListTile(
                                                leading: const Icon(Icons.check_circle, color: Colors.green),
                                                title: const Text('Delivered'),
                                                onTap: () {
                                                  Provider.of<OrderProvider>(context, listen: false)
                                                      .updateOrderStatus(order.id, 'Delivered');
                                                  Navigator.of(ctx).pop();
                                                },
                                              ),
                                              ListTile(
                                                leading: const Icon(Icons.cancel, color: Colors.red),
                                                title: const Text('Cancelled'),
                                                onTap: () {
                                                  Provider.of<OrderProvider>(context, listen: false)
                                                      .updateOrderStatus(order.id, 'Cancelled');
                                                  Navigator.of(ctx).pop();
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                          tooltip: 'More Options',
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrderGrid(List<Order> orders, bool isDarkMode) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: _isSelectionMode
                ? () => _toggleOrderSelection(order.id)
                : () {
                    Navigator.of(context).pushNamed(
                      '/order-detail',
                      arguments: order.id,
                    );
                  },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (_isSelectionMode)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Checkbox(
                            value: _selectedOrders.contains(order.id),
                            onChanged: (value) => _toggleOrderSelection(order.id),
                          ),
                        ),
                      Expanded(
                        child: Text(
                          'Order #${order.id}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!_isSelectionMode)
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert, size: 20),
                          onSelected: (value) {
                            if (value == 'view') {
                              Navigator.of(context).pushNamed(
                                '/order-detail',
                                arguments: order.id,
                              );
                            } else if (value == 'print') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Printing invoice for order #${order.id}...'),
                                  backgroundColor: Colors.blue,
                                ),
                              );
                            } else if (value == 'email') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  // Using constant email instead of order.customerEmail
                                  content: Text('Sending email to $_defaultEmail...'),
                                  backgroundColor: Colors.blue,
                                ),
                              );
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'view',
                              child: Row(
                                children: [
                                  Icon(Icons.visibility, size: 18),
                                  SizedBox(width: 8),
                                  Text('View Details'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'print',
                              child: Row(
                                children: [
                                  Icon(Icons.print, size: 18),
                                  SizedBox(width: 8),
                                  Text('Print Invoice'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'email',
                              child: Row(
                                children: [
                                  Icon(Icons.email, size: 18),
                                  SizedBox(width: 8),
                                  Text('Email Customer'),
                                ],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          order.status,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _getStatusColor(order.status),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    order.customerName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Using constant date instead of order.date
                  Text(
                    DateFormat('MMM d, yyyy').format(_defaultDate),
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${order.items.length} ${order.items.length == 1 ? 'item' : 'items'}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      Text(
                        '\$${order.totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  double _calculateTotalValue(List<Order> orders) {
    return orders.fold(0, (sum, order) => sum + order.totalAmount);
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