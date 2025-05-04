import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../providers/product_provider.dart';
import '../models/product.dart';
import '../widgets/sidebar.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _skuController = TextEditingController();
  
  String _selectedCategory = 'Fruits & Vegetables';
  String _imageUrl = 'assets/images/placeholder.jpg';
  bool _isLoading = false;
  bool _isInit = false;
  
  final List<String> _categories = [
    'Fruits & Vegetables',
    'Dairy & Eggs',
    'Meat & Seafood',
    'Bakery',
    'Beverages',
    'Snacks',
    'Grains',
    'Condiments',
    'Canned Goods',
    'Frozen Foods',
    'Personal Care',
    'Household',
    'Other'
  ];

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      final selectedProduct = productProvider.selectedProduct;
      
      if (selectedProduct != null) {
        // Editing an existing product
        _nameController.text = selectedProduct.name;
        _descriptionController.text = selectedProduct.description;
        _priceController.text = selectedProduct.price.toString();
        _stockController.text = selectedProduct.stock.toString();
        _skuController.text = selectedProduct.sku;
        _selectedCategory = selectedProduct.category;
        _imageUrl = selectedProduct.imageUrl;
      } else {
        // Generate a new SKU based on category and timestamp
        _generateSku();
      }
      
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _skuController.dispose();
    super.dispose();
  }
  
  void _generateSku() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString().substring(9, 13);
    final prefix = _selectedCategory.substring(0, 3).toUpperCase();
    _skuController.text = '$prefix-$timestamp';
  }
  
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        // In a real app, you would upload this image to storage
        // For now, we'll just use a placeholder
        setState(() {
          // In a real app, this would be the URL of the uploaded image
          _imageUrl = 'assets/images/placeholder.jpg';
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image selected (Note: Using placeholder for demo)'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  void _saveProduct() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);
      final selectedProduct = productProvider.selectedProduct;
      
      final name = _nameController.text;
      final description = _descriptionController.text;
      final price = double.parse(_priceController.text);
      final stock = int.parse(_stockController.text);
      final sku = _skuController.text;
      
      if (selectedProduct == null) {
        // Add new product
        final newProduct = Product(
          id: DateTime.now().toString(),
          name: name,
          description: description,
          price: price,
          stock: stock,
          category: _selectedCategory,
          imageUrl: _imageUrl,
          sku: sku,
        );
        
        productProvider.addProduct(newProduct);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product added successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Update existing product
        final updatedProduct = Product(
          id: selectedProduct.id,
          name: name,
          description: description,
          price: price,
          stock: stock,
          category: _selectedCategory,
          imageUrl: _imageUrl,
          sku: sku,
        );
        
        productProvider.updateProduct(selectedProduct.id, updatedProduct);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
      
      // Clear the selected product and navigate back
      productProvider.clearSelectedProduct();
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving product: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
    
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final selectedProduct = productProvider.selectedProduct;
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
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: primaryGreen,
                      ),
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            Container(
                              padding: const EdgeInsets.all(16),
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
                                    icon: const Icon(Icons.arrow_back),
                                    onPressed: () {
                                      productProvider.clearSelectedProduct();
                                      Navigator.of(context).pop();
                                    },
                                    color: primaryGreen,
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    selectedProduct == null ? 'Add New Product' : 'Edit Product',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: primaryGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Form
                            Form(
                              key: _formKey,
                              child: isTablet
                                  ? Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Left column - Image and category
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              _buildImageSection(isDarkMode, primaryGreen, secondaryPurple, cardColor),
                                              const SizedBox(height: 24),
                                              _buildCategorySection(isDarkMode, primaryGreen, secondaryPurple, cardColor),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 24),
                                        // Right column - Product details
                                        Expanded(
                                          flex: 2,
                                          child: _buildProductDetailsSection(isDarkMode, primaryGreen, secondaryPurple, cardColor),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _buildImageSection(isDarkMode, primaryGreen, secondaryPurple, cardColor),
                                        const SizedBox(height: 24),
                                        _buildCategorySection(isDarkMode, primaryGreen, secondaryPurple, cardColor),
                                        const SizedBox(height: 24),
                                        _buildProductDetailsSection(isDarkMode, primaryGreen, secondaryPurple, cardColor),
                                      ],
                                    ),
                            ),
                            const SizedBox(height: 32),
                            // Action Buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                OutlinedButton(
                                  onPressed: () {
                                    productProvider.clearSelectedProduct();
                                    Navigator.of(context).pop();
                                  },
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                                const SizedBox(width: 16),
                                ElevatedButton(
                                  onPressed: _saveProduct,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryGreen,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(selectedProduct == null ? 'Add Product' : 'Save Changes'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection(
    bool isDarkMode, 
    Color primaryGreen, 
    Color secondaryPurple, 
    Color cardColor
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Product Image',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryGreen,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.black12 : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: primaryGreen.withOpacity(0.2),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primaryGreen.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    image: DecorationImage(
                      image: AssetImage(_imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.upload),
                  label: const Text('Upload Image'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryPurple,
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
        ],
      ),
    );
  }

  Widget _buildCategorySection(
    bool isDarkMode, 
    Color primaryGreen, 
    Color secondaryPurple, 
    Color cardColor
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Category',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryGreen,
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: InputDecoration(
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              filled: true,
              fillColor: isDarkMode ? Colors.black12 : Colors.white,
            ),
            items: _categories.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedCategory = newValue;
                  // Update SKU if it's a new product
                  if (Provider.of<ProductProvider>(context, listen: false).selectedProduct == null) {
                    _generateSku();
                  }
                });
              }
            },
            icon: Icon(
              Icons.arrow_drop_down,
              color: primaryGreen,
            ),
            dropdownColor: cardColor,
          ),
        ],
      ),
    );
  }

  Widget _buildProductDetailsSection(
    bool isDarkMode, 
    Color primaryGreen, 
    Color secondaryPurple, 
    Color cardColor
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Product Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryGreen,
            ),
          ),
          const SizedBox(height: 24),
          // Product Name
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Product Name',
              labelStyle: TextStyle(
                color: primaryGreen,
              ),
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              filled: true,
              fillColor: isDarkMode ? Colors.black12 : Colors.white,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a product name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          // Product Description
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Description',
              labelStyle: TextStyle(
                color: primaryGreen,
              ),
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              filled: true,
              fillColor: isDarkMode ? Colors.black12 : Colors.white,
            ),
            maxLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a product description';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          // Price and Stock
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: 'Price (\$)',
                    labelStyle: TextStyle(
                      color: primaryGreen,
                    ),
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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    prefixIcon: Icon(
                      Icons.attach_money,
                      color: primaryGreen,
                    ),
                    filled: true,
                    fillColor: isDarkMode ? Colors.black12 : Colors.white,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid price';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Price must be greater than zero';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _stockController,
                  decoration: InputDecoration(
                    labelText: 'Stock',
                    labelStyle: TextStyle(
                      color: primaryGreen,
                    ),
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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    prefixIcon: Icon(
                      Icons.inventory,
                      color: primaryGreen,
                    ),
                    filled: true,
                    fillColor: isDarkMode ? Colors.black12 : Colors.white,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter stock quantity';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    if (int.parse(value) < 0) {
                      return 'Stock cannot be negative';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // SKU
          TextFormField(
            controller: _skuController,
            decoration: InputDecoration(
              labelText: 'SKU (Stock Keeping Unit)',
              labelStyle: TextStyle(
                color: primaryGreen,
              ),
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              prefixIcon: Icon(
                Icons.qr_code,
                color: primaryGreen,
              ),
              helperText: 'Unique identifier for this product',
              filled: true,
              fillColor: isDarkMode ? Colors.black12 : Colors.white,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a SKU';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
