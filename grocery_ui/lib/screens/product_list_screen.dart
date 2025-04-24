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
                      Text(
                        _isSelectionMode 
                            ? '${_selectedProducts.length} Selected' 
                            : 'Products',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      if (_isSelectionMode) ...[
                        IconButton(
                          icon: Icon(
                            _selectedProducts.length == filteredProducts.length
                                ? Icons.select_all
                                : Icons.deselect,
                            color: Theme.of(context).primaryColor,
                          ),
                          tooltip: _selectedProducts.length == filteredProducts.length
                              ? 'Deselect All'
                              : 'Select All',
                          onPressed: () => _selectAllProducts(filteredProducts),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
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
                          ),
                          child: const Text('Cancel'),
                        ),
                      ] else ...[
                        IconButton(
                          icon: Icon(
                            _isGridView ? Icons.list : Icons.grid_view,
                            color: Theme.of(context).primaryColor,
                          ),
                          tooltip: _isGridView ? 'List View' : 'Grid View',
                          onPressed: () {
                            setState(() {
                              _isGridView = !_isGridView;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.select_all),
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
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
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
                    color: isDarkMode ? const Color(0xFF1A1F38) : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
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
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: () {
                                          setState(() {
                                            _searchController.clear();
                                          });
                                        },
                                      )
                                    : null,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              ),
                              onChanged: (value) {
                                setState(() {});
                              },
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
                                  color: isDarkMode ? Colors.white24 : Colors.black12,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButton<String>(
                                value: _selectedCategory,
                                icon: const Icon(Icons.arrow_drop_down),
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
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Sort By
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isDarkMode ? Colors.white24 : Colors.black12,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButton<String>(
                                value: _sortBy,
                                icon: const Icon(Icons.arrow_drop_down),
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
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Sort Direction
                            IconButton(
                              icon: Icon(
                                _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                                color: Theme.of(context).primaryColor,
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
                          icon: const Icon(Icons.clear),
                          label: const Text('Clear Filters'),
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
                                color: isDarkMode ? Colors.white54 : Colors.black38,
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
                                    backgroundColor: Theme.of(context).primaryColor,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                            ],
                          ),
                        )
                      : _isGridView
                          ? _buildProductGrid(context, filteredProducts, isDarkMode)
                          : _buildProductList(context, filteredProducts, isDarkMode),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(BuildContext context, List<Product> products, bool isDarkMode) {
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
                  ? Theme.of(context).primaryColor.withOpacity(0.1)
                  : isDarkMode
                      ? const Color(0xFF1A1F38)
                      : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: isSelected
                  ? Border.all(color: Theme.of(context).primaryColor, width: 2)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
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
                        activeColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  // Product Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      product.imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
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
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
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
                                color: isDarkMode ? Colors.black12 : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                product.category,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDarkMode ? Colors.white70 : Colors.black54,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: isDarkMode ? Colors.black12 : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'SKU: ${product.sku}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDarkMode ? Colors.white70 : Colors.black54,
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
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStockColor(product.stock).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Stock: ${product.stock}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _getStockColor(product.stock),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (!_isSelectionMode) ...[
                    const SizedBox(width: 16),
                    // Actions
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert),
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
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    productProvider.deleteProduct(product.id);
                                    Navigator.of(ctx).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Product deleted'),
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
                        } else if (value == 'view') {
                          Navigator.of(context).pushNamed(
                            '/product-detail',
                            arguments: product.id,
                          );
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'view',
                          child: Row(
                            children: [
                              Icon(Icons.visibility),
                              SizedBox(width: 8),
                              Text('View Details'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit),
                              SizedBox(width: 8),
                              Text('Edit'),
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

  Widget _buildProductGrid(BuildContext context, List<Product> products, bool isDarkMode) {
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
                  ? Theme.of(context).primaryColor.withOpacity(0.1)
                  : isDarkMode
                      ? const Color(0xFF1A1F38)
                      : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(color: Theme.of(context).primaryColor, width: 2)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
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
                                ? Theme.of(context).primaryColor
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
                          color: _getStockColor(product.stock).withOpacity(0.8),
                          borderRadius: BorderRadius.circular(4),
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
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
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
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.green,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isDarkMode ? Colors.black12 : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Stock: ${product.stock}',
                              style: TextStyle(
                                fontSize: 12,
                                color: _getStockColor(product.stock),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.black12 : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          product.category,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDarkMode ? Colors.white70 : Colors.black54,
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

  Color _getStockColor(int stock) {
    if (stock <= 0) {
      return Colors.red;
    } else if (stock <= 10) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }
}