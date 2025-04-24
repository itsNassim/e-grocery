import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/product_provider.dart';
import '../providers/order_provider.dart';
import '../models/product.dart';
import '../widgets/sidebar.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;
  
  const ProductDetailScreen({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Find the product by ID
    final product = productProvider.products.firstWhere(
      (p) => p.id == widget.productId,
      orElse: () => Product(
        id: 'not-found',
        name: 'Product Not Found',
        description: 'The requested product could not be found.',
        price: 0,
        stock: 0,
        category: 'Unknown',
        imageUrl: 'assets/images/placeholder.jpg',
        sku: 'N/A',
      ),
    );
    
    // If product not found, show error
    if (product.id == 'not-found') {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              const Text(
                'Product Not Found',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'The requested product could not be found.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/products');
                },
                child: const Text('Go to Products'),
              ),
            ],
          ),
        ),
      );
    }
    
    // Mock data for sales history
    final List<Map<String, dynamic>> salesHistory = [
      {
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'quantity': 5,
        'revenue': product.price * 5,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 3)),
        'quantity': 3,
        'revenue': product.price * 3,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 7)),
        'quantity': 8,
        'revenue': product.price * 8,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 10)),
        'quantity': 2,
        'revenue': product.price * 2,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 15)),
        'quantity': 6,
        'revenue': product.price * 6,
      },
    ];
    
    // Calculate total sales and revenue
    final totalSales = salesHistory.fold(0, (sum, item) => sum + (item['quantity'] as int));
    final totalRevenue = salesHistory.fold(0.0, (sum, item) => sum + (item['revenue'] as double));
    
    // Mock data for inventory history
    final List<Map<String, dynamic>> inventoryHistory = [
      {
        'date': DateTime.now().subtract(const Duration(days: 2)),
        'action': 'Restock',
        'quantity': 20,
        'previousStock': product.stock - 20,
        'newStock': product.stock,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 5)),
        'action': 'Sale',
        'quantity': -8,
        'previousStock': product.stock - 12,
        'newStock': product.stock - 20,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 8)),
        'action': 'Restock',
        'quantity': 15,
        'previousStock': product.stock - 27,
        'newStock': product.stock - 12,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 12)),
        'action': 'Sale',
        'quantity': -10,
        'previousStock': product.stock - 17,
        'newStock': product.stock - 27,
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 18)),
        'action': 'Initial Stock',
        'quantity': 30,
        'previousStock': 0,
        'newStock': product.stock - 17,
      },
    ];
    
    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            selectedIndex: 1, // Products tab
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
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Product Details',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: () {
                          productProvider.setSelectedProduct(product);
                          Navigator.of(context).pushNamed('/edit-product');
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit Product'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Overview
                          _buildProductOverview(context, product, isDarkMode),
                          const SizedBox(height: 24),
                          // Tabs
                          Container(
                            decoration: BoxDecoration(
                              color: isDarkMode ? const Color(0xFF1A1F38) : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                TabBar(
                                  controller: _tabController,
                                  labelColor: Theme.of(context).primaryColor,
                                  unselectedLabelColor: isDarkMode ? Colors.white54 : Colors.black54,
                                  indicatorColor: Theme.of(context).primaryColor,
                                  tabs: const [
                                    Tab(text: 'Details'),
                                    Tab(text: 'Sales History'),
                                    Tab(text: 'Inventory History'),
                                  ],
                                ),
                                SizedBox(
                                  height: 400,
                                  child: TabBarView(
                                    controller: _tabController,
                                    children: [
                                      // Details Tab
                                      _buildDetailsTab(context, product, isDarkMode),
                                      // Sales History Tab
                                      _buildSalesHistoryTab(context, salesHistory, totalSales, totalRevenue, isDarkMode),
                                      // Inventory History Tab
                                      _buildInventoryHistoryTab(context, inventoryHistory, isDarkMode),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductOverview(BuildContext context, Product product, bool isDarkMode) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1A1F38) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: isTablet
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    product.imageUrl,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 24),
                // Product Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.description,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _buildInfoCard(
                            context,
                            'Price',
                            '\$${product.price.toStringAsFixed(2)}',
                            Icons.attach_money,
                            Colors.green,
                            isDarkMode,
                          ),
                          const SizedBox(width: 16),
                          _buildInfoCard(
                            context,
                            'Stock',
                            product.stock.toString(),
                            Icons.inventory,
                            product.stock > 10 ? Colors.green : product.stock > 0 ? Colors.orange : Colors.red,
                            isDarkMode,
                          ),
                          const SizedBox(width: 16),
                          _buildInfoCard(
                            context,
                            'Category',
                            product.category,
                            Icons.category,
                            Colors.blue,
                            isDarkMode,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.black12 : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.qr_code),
                            const SizedBox(width: 8),
                            Text(
                              'SKU: ${product.sku}',
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
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      product.imageUrl,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Product Info
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product.description,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildInfoCard(
                        context,
                        'Price',
                        '\$${product.price.toStringAsFixed(2)}',
                        Icons.attach_money,
                        Colors.green,
                        isDarkMode,
                      ),
                      const SizedBox(width: 16),
                      _buildInfoCard(
                        context,
                        'Stock',
                        product.stock.toString(),
                        Icons.inventory,
                        product.stock > 10 ? Colors.green : product.stock > 0 ? Colors.orange : Colors.red,
                        isDarkMode,
                      ),
                      const SizedBox(width: 16),
                      _buildInfoCard(
                        context,
                        'Category',
                        product.category,
                        Icons.category,
                        Colors.blue,
                        isDarkMode,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.black12 : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.qr_code),
                      const SizedBox(width: 8),
                      Text(
                        'SKU: ${product.sku}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
    bool isDarkMode,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.black12 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsTab(BuildContext context, Product product, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Product Specifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSpecificationRow('Product Name', product.name, isDarkMode),
          _buildSpecificationRow('Description', product.description, isDarkMode),
          _buildSpecificationRow('Category', product.category, isDarkMode),
          _buildSpecificationRow('Price', '\$${product.price.toStringAsFixed(2)}', isDarkMode),
          _buildSpecificationRow('Stock', product.stock.toString(), isDarkMode),
          _buildSpecificationRow('SKU', product.sku, isDarkMode),
          _buildSpecificationRow('Created At', 'June 15, 2023', isDarkMode), // Mock data
          _buildSpecificationRow('Last Updated', 'July 3, 2023', isDarkMode), // Mock data
          const SizedBox(height: 24),
          const Text(
            'Additional Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSpecificationRow('Weight', '0.5 kg', isDarkMode), // Mock data
          _buildSpecificationRow('Dimensions', '10 × 5 × 5 cm', isDarkMode), // Mock data
          _buildSpecificationRow('Manufacturer', 'Local Farms Co.', isDarkMode), // Mock data
          _buildSpecificationRow('Country of Origin', 'United States', isDarkMode), // Mock data
        ],
      ),
    );
  }

  Widget _buildSpecificationRow(String label, String value, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white70 : Colors.black54,
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

  Widget _buildSalesHistoryTab(
    BuildContext context,
    List<Map<String, dynamic>> salesHistory,
    int totalSales,
    double totalRevenue,
    bool isDarkMode,
  ) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sales Summary
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.black12 : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Units Sold',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        totalSales.toString(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.black12 : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Revenue',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${totalRevenue.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Sales History Table
          const Text(
            'Recent Sales',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: isDarkMode ? Colors.white24 : Colors.black12,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                // Table Header
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.black12 : Colors.grey.shade100,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    children: const [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Date',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Quantity',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Revenue',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
                // Table Rows
                ...salesHistory.map((sale) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: isDarkMode ? Colors.white24 : Colors.black12,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            DateFormat('MMM d, yyyy').format(sale['date'] as DateTime),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            (sale['quantity'] as int).toString(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            '\$${(sale['revenue'] as double).toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.green,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryHistoryTab(
    BuildContext context,
    List<Map<String, dynamic>> inventoryHistory,
    bool isDarkMode,
  ) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Inventory History',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: isDarkMode ? Colors.white24 : Colors.black12,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                // Table Header
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.black12 : Colors.grey.shade100,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    children: const [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Date',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Action',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Quantity',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Stock',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
                // Table Rows
                ...inventoryHistory.map((record) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: isDarkMode ? Colors.white24 : Colors.black12,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            DateFormat('MMM d, yyyy').format(record['date'] as DateTime),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getActionColor(record['action'] as String).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              record['action'] as String,
                              style: TextStyle(
                                color: _getActionColor(record['action'] as String),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            (record['quantity'] as int) > 0
                                ? '+${record['quantity']}'
                                : '${record['quantity']}',
                            style: TextStyle(
                              color: (record['quantity'] as int) > 0 ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            '${record['previousStock']} → ${record['newStock']}',
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getActionColor(String action) {
    switch (action) {
      case 'Restock':
        return Colors.green;
      case 'Sale':
        return Colors.blue;
      case 'Initial Stock':
        return Colors.purple;
      case 'Adjustment':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}