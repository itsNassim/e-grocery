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
  bool _isEditingStock = false;
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _stockController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Define theme colors to match dashboard
    final primaryGreen = const Color(0xFF2E7D32);
    final secondaryPurple = const Color(0xFF6A1B9A);
    final lightGreen = const Color(0xFF4CAF50);
    final lightPurple = const Color(0xFF9C27B0);
    final bgColor = isDarkMode ? const Color(0xFF0A1F0A) : Colors.white;
    final cardColor = isDarkMode ? const Color(0xFF1A2F1A) : Colors.white;
    
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
              Icon(
                Icons.error_outline,
                size: 64,
                color: secondaryPurple,
              ),
              const SizedBox(height: 16),
              Text(
                'Product Not Found',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryGreen,
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
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
        'note': 'Regular monthly restock',
        'user': 'Admin',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 5)),
        'action': 'Sale',
        'quantity': -8,
        'previousStock': product.stock - 12,
        'newStock': product.stock - 20,
        'note': 'Order #12345',
        'user': 'System',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 8)),
        'action': 'Restock',
        'quantity': 15,
        'previousStock': product.stock - 27,
        'newStock': product.stock - 12,
        'note': 'Emergency restock',
        'user': 'Admin',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 12)),
        'action': 'Sale',
        'quantity': -10,
        'previousStock': product.stock - 17,
        'newStock': product.stock - 27,
        'note': 'Order #12340',
        'user': 'System',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 18)),
        'action': 'Initial Stock',
        'quantity': 30,
        'previousStock': 0,
        'newStock': product.stock - 17,
        'note': 'Initial inventory',
        'user': 'Admin',
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
            child: Container(
              color: bgColor,
              child: Column(
                children: [
                  // App Bar
                  Container(
                    padding: const EdgeInsets.all(16),
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
                          icon: Icon(Icons.arrow_back, color: primaryGreen),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Product Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryGreen,
                          ),
                        ),
                        const Spacer(),
                        PopupMenuButton<String>(
                          icon: Icon(
                            Icons.more_vert,
                            color: primaryGreen,
                          ),
                          onSelected: (value) {
                            if (value == 'edit') {
                              productProvider.setSelectedProduct(product);
                              Navigator.of(context).pushNamed('/edit-product');
                            } else if (value == 'delete') {
                              _showDeleteConfirmation(context, product, productProvider, primaryGreen, secondaryPurple);
                            } else if (value == 'duplicate') {
                              // Duplicate product logic would go here
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Product duplicated'),
                                  backgroundColor: primaryGreen,
                                ),
                              );
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, color: secondaryPurple),
                                  const SizedBox(width: 8),
                                  const Text('Edit Product'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'duplicate',
                              child: Row(
                                children: [
                                  Icon(Icons.content_copy, color: primaryGreen),
                                  const SizedBox(width: 8),
                                  const Text('Duplicate Product'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Delete Product'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () {
                            productProvider.setSelectedProduct(product);
                            Navigator.of(context).pushNamed('/edit-product');
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit Product'),
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
                            _buildProductOverview(context, product, isDarkMode, primaryGreen, secondaryPurple),
                            const SizedBox(height: 24),
                            // Quick Actions
                            _buildQuickActions(context, product, isDarkMode, primaryGreen, secondaryPurple),
                            const SizedBox(height: 24),
                            // Tabs
                            Container(
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
                              child: Column(
                                children: [
                                  TabBar(
                                    controller: _tabController,
                                    labelColor: primaryGreen,
                                    unselectedLabelColor: isDarkMode ? Colors.white54 : Colors.black54,
                                    indicatorColor: secondaryPurple,
                                    tabs: const [
                                      Tab(text: 'Details'),
                                      Tab(text: 'Sales History'),
                                      Tab(text: 'Inventory History'),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 500,
                                    child: TabBarView(
                                      controller: _tabController,
                                      children: [
                                        // Details Tab
                                        _buildDetailsTab(context, product, isDarkMode, primaryGreen, secondaryPurple),
                                        // Sales History Tab
                                        _buildSalesHistoryTab(context, salesHistory, totalSales, totalRevenue, isDarkMode, primaryGreen, secondaryPurple),
                                        // Inventory History Tab
                                        _buildInventoryHistoryTab(context, inventoryHistory, isDarkMode, primaryGreen, secondaryPurple),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Related Products
                            _buildRelatedProducts(context, productProvider, isDarkMode, primaryGreen, secondaryPurple),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showUpdateStockDialog(context, product, productProvider, primaryGreen, secondaryPurple);
        },
        backgroundColor: primaryGreen,
        child: const Icon(Icons.inventory),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context, 
    Product product, 
    ProductProvider productProvider,
    Color primaryGreen,
    Color secondaryPurple,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Delete Product',
          style: TextStyle(
            color: primaryGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to delete "${product.name}"?'),
            const SizedBox(height: 16),
            Text(
              'This action cannot be undone.',
              style: TextStyle(
                color: Colors.red.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: secondaryPurple,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              productProvider.deleteProduct(product.id);
              Navigator.of(ctx).pop();
              Navigator.of(context).pop(); // Go back to products list
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${product.name} has been deleted'),
                  backgroundColor: primaryGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showUpdateStockDialog(
    BuildContext context, 
    Product product, 
    ProductProvider productProvider,
    Color primaryGreen,
    Color secondaryPurple,
  ) {
    _stockController.text = '';
    _noteController.text = '';
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Update Inventory',
          style: TextStyle(
            color: primaryGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Current Stock: ${product.stock}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _stockController,
              decoration: InputDecoration(
                labelText: 'Quantity to Add/Remove',
                hintText: 'Enter a positive or negative number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.inventory),
              ),
              keyboardType: TextInputType.numberWithOptions(signed: true),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: 'Note',
                hintText: 'Add a note about this inventory change',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.note),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: secondaryPurple,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_stockController.text.isNotEmpty) {
                try {
                  final change = int.parse(_stockController.text);
                  final newStock = product.stock + change;
                  
                  if (newStock < 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Stock cannot be negative'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  
                  // Update product stock
                  final updatedProduct = Product(
                    id: product.id,
                    name: product.name,
                    description: product.description,
                    price: product.price,
                    stock: newStock,
                    category: product.category,
                    imageUrl: product.imageUrl,
                    sku: product.sku,
                  );
                  
                  productProvider.updateProduct(product.id, updatedProduct);
                  
                  Navigator.of(ctx).pop();
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        change > 0
                            ? 'Added $change items to inventory'
                            : 'Removed ${change.abs()} items from inventory',
                      ),
                      backgroundColor: primaryGreen,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid number'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              foregroundColor: Colors.white,
            ),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  Widget _buildProductOverview(BuildContext context, Product product, bool isDarkMode, Color primaryGreen, Color secondaryPurple) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1A2F1A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: primaryGreen.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: primaryGreen.withOpacity(0.2),
          width: 1,
        ),
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
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: primaryGreen,
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
                            primaryGreen,
                            isDarkMode,
                          ),
                          const SizedBox(width: 16),
                          _buildInfoCard(
                            context,
                            'Stock',
                            product.stock.toString(),
                            Icons.inventory,
                            product.stock > 10 ? primaryGreen : product.stock > 0 ? Colors.orange : Colors.red,
                            isDarkMode,
                          ),
                          const SizedBox(width: 16),
                          _buildInfoCard(
                            context,
                            'Category',
                            product.category,
                            Icons.category,
                            secondaryPurple,
                            isDarkMode,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.black12 : const Color(0xFFF5F8F5),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: primaryGreen.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.qr_code, color: secondaryPurple),
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
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryGreen,
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
                        primaryGreen,
                        isDarkMode,
                      ),
                      const SizedBox(width: 16),
                      _buildInfoCard(
                        context,
                        'Stock',
                        product.stock.toString(),
                        Icons.inventory,
                        product.stock > 10 ? primaryGreen : product.stock > 0 ? Colors.orange : Colors.red,
                        isDarkMode,
                      ),
                      const SizedBox(width: 16),
                      _buildInfoCard(
                        context,
                        'Category',
                        product.category,
                        Icons.category,
                        secondaryPurple,
                        isDarkMode,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.black12 : const Color(0xFFF5F8F5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: primaryGreen.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.qr_code, color: secondaryPurple),
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

  Widget _buildQuickActions(BuildContext context, Product product, bool isDarkMode, Color primaryGreen, Color secondaryPurple) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1A2F1A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: primaryGreen.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: primaryGreen.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryGreen,
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildActionButton(
                  context,
                  'Update Stock',
                  Icons.inventory,
                  primaryGreen,
                  () {
                    _showUpdateStockDialog(
                      context, 
                      product, 
                      Provider.of<ProductProvider>(context, listen: false),
                      primaryGreen,
                      secondaryPurple,
                    );
                  },
                ),
                const SizedBox(width: 12),
                _buildActionButton(
                  context,
                  'Edit Product',
                  Icons.edit,
                  secondaryPurple,
                  () {
                    Provider.of<ProductProvider>(context, listen: false).setSelectedProduct(product);
                    Navigator.of(context).pushNamed('/edit-product');
                  },
                ),
                const SizedBox(width: 12),
                _buildActionButton(
                  context,
                  'Print Barcode',
                  Icons.print,
                  Colors.blue.shade700,
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Printing barcode...'),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 12),
                _buildActionButton(
                  context,
                  'Add to Featured',
                  Icons.star,
                  Colors.amber,
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Added to featured products'),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 12),
                _buildActionButton(
                  context,
                  'Delete Product',
                  Icons.delete,
                  Colors.red,
                  () {
                    _showDeleteConfirmation(
                      context, 
                      product, 
                      Provider.of<ProductProvider>(context, listen: false),
                      primaryGreen,
                      secondaryPurple,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
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
          color: isDarkMode ? Colors.black12 : const Color(0xFFF5F8F5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
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

  Widget _buildDetailsTab(
    BuildContext context, 
    Product product, 
    bool isDarkMode, 
    Color primaryGreen,
    Color secondaryPurple,
  ) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Product Specifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryGreen,
            ),
          ),
          const SizedBox(height: 16),
          _buildSpecificationRow('Product Name', product.name, isDarkMode, primaryGreen),
          _buildSpecificationRow('Description', product.description, isDarkMode, primaryGreen),
          _buildSpecificationRow('Category', product.category, isDarkMode, primaryGreen),
          _buildSpecificationRow('Price', '\$${product.price.toStringAsFixed(2)}', isDarkMode, primaryGreen),
          _buildSpecificationRow('Stock', product.stock.toString(), isDarkMode, primaryGreen),
          _buildSpecificationRow('SKU', product.sku, isDarkMode, primaryGreen),
          _buildSpecificationRow('Created At', 'June 15, 2023', isDarkMode, primaryGreen), // Mock data
          _buildSpecificationRow('Last Updated', 'July 3, 2023', isDarkMode, primaryGreen), // Mock data
          const SizedBox(height: 24),
          Text(
            'Additional Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryGreen,
            ),
          ),
          const SizedBox(height: 16),
          _buildSpecificationRow('Weight', '0.5 kg', isDarkMode, primaryGreen), // Mock data
          _buildSpecificationRow('Dimensions', '10 × 5 × 5 cm', isDarkMode, primaryGreen), // Mock data
          _buildSpecificationRow('Manufacturer', 'Local Farms Co.', isDarkMode, primaryGreen), // Mock data
          _buildSpecificationRow('Country of Origin', 'United States', isDarkMode, primaryGreen), // Mock data
          const SizedBox(height: 24),
          Text(
            'Product Tags',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryGreen,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildTag('Fresh', primaryGreen),
              _buildTag('Organic', secondaryPurple),
              _buildTag('Local', primaryGreen),
              _buildTag('Seasonal', secondaryPurple),
              _buildTag('Healthy', primaryGreen),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSpecificationRow(String label, String value, bool isDarkMode, Color primaryGreen) {
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
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: primaryGreen,
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
    Color primaryGreen,
    Color secondaryPurple,
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
                    color: isDarkMode ? Colors.black12 : const Color(0xFFF5F8F5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: primaryGreen.withOpacity(0.2),
                      width: 1,
                    ),
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
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: secondaryPurple,
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
                    color: isDarkMode ? Colors.black12 : const Color(0xFFF5F8F5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: primaryGreen.withOpacity(0.2),
                      width: 1,
                    ),
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
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: primaryGreen,
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
          Text(
            'Recent Sales',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryGreen,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: primaryGreen.withOpacity(0.2),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                // Table Header
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.black12 : const Color(0xFFF5F8F5),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Date',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryGreen,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Quantity',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryGreen,
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
                            color: primaryGreen,
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
                          color: primaryGreen.withOpacity(0.1),
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            DateFormat('MMM d, yyyy').format(sale['date'] as DateTime),
                            style: TextStyle(
                              color: secondaryPurple,
                            ),
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
                            style: TextStyle(
                              color: primaryGreen,
                              fontWeight: FontWeight.bold,
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
          const SizedBox(height: 24),
          Center(
            child: OutlinedButton(
              onPressed: () {
                // View full sales history
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryGreen,
                side: BorderSide(color: primaryGreen),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('View Full Sales History'),
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
    Color primaryGreen,
    Color secondaryPurple,
  ) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Inventory History',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryGreen,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  _showUpdateStockDialog(
                    context, 
                    Provider.of<ProductProvider>(context, listen: false).products.firstWhere(
                      (p) => p.id == widget.productId,
                    ), 
                    Provider.of<ProductProvider>(context, listen: false),
                    primaryGreen,
                    secondaryPurple,
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Update Stock'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: primaryGreen.withOpacity(0.2),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                // Table Header
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.black12 : const Color(0xFFF5F8F5),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Date',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryGreen,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Action',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryGreen,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Quantity',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryGreen,
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
                            color: primaryGreen,
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
                          color: primaryGreen.withOpacity(0.1),
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
                              border: Border.all(
                                color: _getActionColor(record['action'] as String).withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              record['action'] as String,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: _getActionColor(record['action'] as String),
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
                              color: (record['quantity'] as int) > 0 ? primaryGreen : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            '${record['newStock']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
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
          const SizedBox(height: 16),
          ExpansionTile(
            title: Text(
              'Inventory Notes',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryGreen,
              ),
            ),
            children: inventoryHistory.map((record) {
              return ListTile(
                title: Text(
                  DateFormat('MMM d, yyyy').format(record['date'] as DateTime),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: secondaryPurple,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      '${record['action']}: ${(record['quantity'] as int) > 0 ? '+${record['quantity']}' : record['quantity']} items',
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Note: ${record['note']}',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'By: ${record['user']}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? Colors.white54 : Colors.black45,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
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
      case 'Adjustment':
        return Colors.orange;
      case 'Initial Stock':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Widget _buildRelatedProducts(
    BuildContext context,
    ProductProvider productProvider,
    bool isDarkMode,
    Color primaryGreen,
    Color secondaryPurple,
  ) {
    // Get products in the same category
    final currentProduct = productProvider.products.firstWhere(
      (p) => p.id == widget.productId,
    );
    
    final relatedProducts = productProvider.products
        .where((p) => p.category == currentProduct.category && p.id != currentProduct.id)
        .take(4)
        .toList();
    
    if (relatedProducts.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Related Products',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primaryGreen,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: relatedProducts.length,
            itemBuilder: (context, index) {
              final product = relatedProducts[index];
              return Container(
                width: 200,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF1A2F1A) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: primaryGreen.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(
                    color: primaryGreen.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed(
                      '/product-detail',
                      arguments: product.id,
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: Image.asset(
                          product.imageUrl,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: primaryGreen,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product.description,
                              style: TextStyle(
                                color: isDarkMode ? Colors.white70 : Colors.black54,
                                fontSize: 12,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: secondaryPurple,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: primaryGreen.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'Stock: ${product.stock}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: primaryGreen,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
