import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../models/product.dart';
import '../widgets/sidebar.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All Categories';
  String _sortBy = 'Name';
  bool _sortAscending = true;
  bool _isGridView = false;
  List<String> _selectedProducts = [];
  bool _isSelectionMode = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedProducts = [];
      }
    });
  }

  void _toggleProductSelection(String productId) {
    setState(() {
      if (_selectedProducts.contains(productId)) {
        _selectedProducts.remove(productId);
      } else {
        _selectedProducts.add(productId);
      }
    });
  }

  void _selectAllProducts(List<Product> products) {
    setState(() {
      if (_selectedProducts.length == products.length) {
        _selectedProducts = [];
      } else {
        _selectedProducts = products.map((p) => p.id).toList();
      }
    });
  }

  void _deleteSelectedProducts(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete ${_selectedProducts.length} selected products?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final productProvider = Provider.of<ProductProvider>(context, listen: false);
              for (var id in _selectedProducts) {
                productProvider.deleteProduct(id);
              }
              setState(() {
                _selectedProducts = [];
                _isSelectionMode = false;
              });
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${_selectedProducts.length} products deleted'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Delete'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  List<Product> _getSortedProducts(List<Product> products) {
    switch (_sortBy) {
      case 'Name':
        products.sort((a, b) => _sortAscending ? a.name.compareTo(b.name) : b.name.compareTo(a.name));
        break;
      case 'Price':
        products.sort((a, b) => _sortAscending ? a.price.compareTo(b.price) : b.price.compareTo(a.price));
        break;
      case 'Stock':
        products.sort((a, b) => _sortAscending ? a.stock.compareTo(b.stock) : b.stock.compareTo(a.stock));
        break;
      case 'Category':
        products.sort((a, b) => _sortAscending ? a.category.compareTo(b.category) : b.category.compareTo(a.category));
        break;
    }
    return products;
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    
    // Define theme colors
    final primaryGreen = const Color(0xFF2E7D32);
    final secondaryPurple = const Color(0xFF6A1B9A);
    final lightGreen = const Color(0xFF4CAF50);
    final lightPurple = const Color(0xFF9C27B0);
    final bgColor = isDarkMode ? const Color(0xFF0A1F0A) : Colors.white;
    final cardColor = isDarkMode ? const Color(0xFF1A2F1A) : Colors.white;
    
    // Get filtered and sorted products
    List<Product> filteredProducts = productProvider.searchProducts(_searchController.text);
    if (_selectedCategory != 'All Categories') {
      filteredProducts = productProvider.filterByCategory(_selectedCategory);
    }
    filteredProducts = _getSortedProducts(filteredProducts);
    
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
                        Text(
                          _isSelectionMode 
                              ? '${_selectedProducts.length} Selected' 
                              : 'Products',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryGreen,
                          ),
                        ),
                        const Spacer(),
                        if (_isSelectionMode) ...[
                          IconButton(
                            icon: Icon(
                              _selectedProducts.length == filteredProducts.length
                                  ? Icons.select_all
                                  : Icons.deselect,
                              color: primaryGreen,
                            ),
                            tooltip: _selectedProducts.length == filteredProducts.length
                                ? 'Deselect All'
                                : 'Select All',
                            onPressed: () => _selectAllProducts(filteredProducts),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: secondaryPurple),
                            tooltip: 'Delete Selected',
                            onPressed: _selectedProducts.isEmpty
                                ? null
                                : () => _deleteSelectedProducts(context),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: _toggleSelectionMode,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              side: BorderSide(
                                color: secondaryPurple,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: secondaryPurple,
                              ),
                            ),
                          ),
                        ] else ...[
                          IconButton(
                            icon: Icon(
                              _isGridView ? Icons.list : Icons.grid_view,
                              color: primaryGreen,
                            ),
                            tooltip: _isGridView ? 'List View' : 'Grid View',
                            onPressed: () {
                              setState(() {
                                _isGridView = !_isGridView;
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.select_all,
                              color: primaryGreen,
                            ),
                            tooltip: 'Select Mode',
                            onPressed: _toggleSelectionMode,
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: () {
                              productProvider.clearSelectedProduct();
                              Navigator.of(context).pushNamed('/edit-product');
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Add Product'),
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
                      ],
                    ),
                  ),
                  // Search and Filter Bar
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: primaryGreen.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: 'Search products by name, description or SKU',
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: primaryGreen,
                                  ),
                                  suffixIcon: _searchController.text.isNotEmpty
                                      ? IconButton(
                                          icon: Icon(
                                            Icons.clear,
                                            color: primaryGreen,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _searchController.clear();
                                            });
                                          },
                                        )
                                      : null,
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
                                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                  filled: true,
                                  fillColor: isDarkMode ? Colors.black12 : Colors.white,
                                ),
                                onChanged: (value) {
                                  setState(() {});
                                },
                                style: TextStyle(
                                  color: isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              // Category Filter
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: primaryGreen.withOpacity(0.2),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: DropdownButton<String>(
                                  value: _selectedCategory,
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: primaryGreen,
                                  ),
                                  underline: const SizedBox(),
                                  items: productProvider.categories
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        _selectedCategory = newValue;
                                      });
                                    }
                                  },
                                  dropdownColor: cardColor,
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Sort By
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: primaryGreen.withOpacity(0.2),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: DropdownButton<String>(
                                  value: _sortBy,
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: primaryGreen,
                                  ),
                                  underline: const SizedBox(),
                                  items: ['Name', 'Price', 'Stock', 'Category']
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text('Sort by: $value'),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        _sortBy = newValue;
                                      });
                                    }
                                  },
                                  dropdownColor: cardColor,
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Sort Direction
                              IconButton(
                                icon: Icon(
                                  _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                                  color: primaryGreen,
                                ),
                                tooltip: _sortAscending ? 'Sort Ascending' : 'Sort Descending',
                                onPressed: () {
                                  setState(() {
                                    _sortAscending = !_sortAscending;
                                  });
                                },
                              ),
                              const SizedBox(width: 16),
                              // Stock Filter
                              OutlinedButton.icon(
                                onPressed: () {
                                  // Filter by low stock
                                  setState(() {
                                    _searchController.text = '';
                                    _selectedCategory = 'All Categories';
                                    _sortBy = 'Stock';
                                    _sortAscending = true;
                                  });
                                },
                                icon: const Icon(Icons.warning_amber),
                                label: const Text('Low Stock'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.orange,
                                  side: const BorderSide(color: Colors.orange),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Out of Stock Filter
                              OutlinedButton.icon(
                                onPressed: () {
                                  // Filter by out of stock
                                  setState(() {
                                    _searchController.text = '';
                                    _selectedCategory = 'All Categories';
                                    _sortBy = 'Stock';
                                    _sortAscending = true;
                                  });
                                  // This is a simplified approach - in a real app, you'd filter for stock == 0
                                },
                                icon: const Icon(Icons.inventory),
                                label: const Text('Out of Stock'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  side: const BorderSide(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Product Count and Results
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Text(
                          '${filteredProducts.length} products found',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white70 : Colors.black54,
                          ),
                        ),
                        const Spacer(),
                        if (filteredProducts.isEmpty && _searchController.text.isNotEmpty)
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _selectedCategory = 'All Categories';
                              });
                            },
                            icon: Icon(
                              Icons.clear,
                              color: secondaryPurple,
                            ),
                            label: Text(
                              'Clear Filters',
                              style: TextStyle(
                                color: secondaryPurple,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Product List
                  Expanded(
                    child: filteredProducts.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.inventory_2_outlined,
                                  size: 64,
                                  color: isDarkMode ? primaryGreen.withOpacity(0.3) : primaryGreen.withOpacity(0.2),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _searchController.text.isNotEmpty
                                      ? 'No products match your search'
                                      : 'No products found',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: isDarkMode ? Colors.white70 : Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                if (_searchController.text.isNotEmpty)
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _searchController.clear();
                                        _selectedCategory = 'All Categories';
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: secondaryPurple,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: const Text('Clear Search'),
                                  )
                                else
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      productProvider.clearSelectedProduct();
                                      Navigator.of(context).pushNamed('/edit-product');
                                    },
                                    icon: const Icon(Icons.add),
                                    label: const Text('Add Your First Product'),
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
                          )
                        : _isGridView
                            ? _buildProductGrid(context, filteredProducts, isDarkMode, primaryGreen, secondaryPurple, cardColor)
                            : _buildProductList(context, filteredProducts, isDarkMode, primaryGreen, secondaryPurple, cardColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(
    BuildContext context, 
    List<Product> products, 
    bool isDarkMode,
    Color primaryGreen,
    Color secondaryPurple,
    Color cardColor,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: products.length,
      itemBuilder: (ctx, index) {
        final product = products[index];
        final isSelected = _selectedProducts.contains(product.id);
        
        return GestureDetector(
          onTap: _isSelectionMode
              ? () => _toggleProductSelection(product.id)
              : () {
                  Navigator.of(context).pushNamed(
                    '/product-detail',
                    arguments: product.id,
                  );
                },
          onLongPress: !_isSelectionMode
              ? () {
                  _toggleSelectionMode();
                  _toggleProductSelection(product.id);
                }
              : null,
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? primaryGreen.withOpacity(0.1)
                  : cardColor,
              borderRadius: BorderRadius.circular(8),
              border: isSelected
                  ? Border.all(color: primaryGreen, width: 2)
                  : Border.all(
                      color: primaryGreen.withOpacity(0.1),
                      width: 1,
                    ),
              boxShadow: [
                BoxShadow(
                  color: primaryGreen.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  if (_isSelectionMode)
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Checkbox(
                        value: isSelected,
                        onChanged: (bool? value) {
                          _toggleProductSelection(product.id);
                        },
                        activeColor: primaryGreen,
                        checkColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  // Product Image
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: primaryGreen.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        product.imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Product Info
                  Expanded(
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
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isDarkMode ? Colors.white70 : Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: secondaryPurple.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: secondaryPurple.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                product.category,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: secondaryPurple,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: primaryGreen.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: primaryGreen.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                'SKU: ${product.sku}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: primaryGreen,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Price and Stock
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: primaryGreen,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStockColor(product.stock, primaryGreen).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: _getStockColor(product.stock, primaryGreen).withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'Stock: ${product.stock}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _getStockColor(product.stock, primaryGreen),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (!_isSelectionMode) ...[
                    const SizedBox(width: 16),
                    // Actions
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert,
                        color: primaryGreen,
                      ),
                      onSelected: (String value) {
                        final productProvider = Provider.of<ProductProvider>(context, listen: false);
                        if (value == 'edit') {
                          productProvider.setSelectedProduct(product);
                          Navigator.of(context).pushNamed('/edit-product');
                        } else if (value == 'delete') {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Confirm Deletion'),
                              content: Text('Are you sure you want to delete ${product.name}?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(color: secondaryPurple),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    productProvider.deleteProduct(product.id);
                                    Navigator.of(ctx).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text('Product deleted'),
                                        backgroundColor: primaryGreen,
                                      ),
                                    );
                                  },
                                  child: const Text('Delete'),
                                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                                ),
                              ],
                            ),
                          );
                        } else if (value == 'view') {
                          Navigator.of(context).pushNamed(
                            '/product-detail',
                            arguments: product.id,
                          );
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'view',
                          child: Row(
                            children: [
                              Icon(Icons.visibility, color: primaryGreen),
                              const SizedBox(width: 8),
                              const Text('View Details'),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, color: secondaryPurple),
                              const SizedBox(width: 8),
                              const Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Delete', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductGrid(
    BuildContext context, 
    List<Product> products, 
    bool isDarkMode,
    Color primaryGreen,
    Color secondaryPurple,
    Color cardColor,
  ) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: products.length,
      itemBuilder: (ctx, index) {
        final product = products[index];
        final isSelected = _selectedProducts.contains(product.id);
        
        return GestureDetector(
          onTap: _isSelectionMode
              ? () => _toggleProductSelection(product.id)
              : () {
                  Navigator.of(context).pushNamed(
                    '/product-detail',
                    arguments: product.id,
                  );
                },
          onLongPress: !_isSelectionMode
              ? () {
                  _toggleSelectionMode();
                  _toggleProductSelection(product.id);
                }
              : null,
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? primaryGreen.withOpacity(0.1)
                  : cardColor,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(color: primaryGreen, width: 2)
                  : Border.all(
                      color: primaryGreen.withOpacity(0.1),
                      width: 1,
                    ),
              boxShadow: [
                BoxShadow(
                  color: primaryGreen.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: Image.asset(
                        product.imageUrl,
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (_isSelectionMode)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? primaryGreen
                                : Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: Icon(
                              isSelected ? Icons.check : Icons.circle_outlined,
                              color: isSelected ? Colors.white : Colors.grey,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStockColor(product.stock, primaryGreen).withOpacity(0.8),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Text(
                          product.stock > 0 ? 'In Stock' : 'Out of Stock',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Product Info
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
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                          fontSize: 12,
                        ),
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
                              color: primaryGreen,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isDarkMode ? Colors.black12 : primaryGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: primaryGreen.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              'Stock: ${product.stock}',
                              style: TextStyle(
                                fontSize: 12,
                                color: _getStockColor(product.stock, primaryGreen),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: secondaryPurple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: secondaryPurple.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          product.category,
                          style: TextStyle(
                            fontSize: 12,
                            color: secondaryPurple,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getStockColor(int stock, Color primaryGreen) {
    if (stock <= 0) {
      return Colors.red;
    } else if (stock <= 10) {
      return Colors.orange;
    } else {
      return primaryGreen;
    }
  }
}
