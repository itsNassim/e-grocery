import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../widgets/sidebar.dart';
import '../providers/product_provider.dart';
import '../providers/order_provider.dart';
import '../providers/statistics_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  String _selectedMonth = 'June 2023'; // Default selected month

  final List<String> _availableMonths = [
    'January 2023',
    'February 2023',
    'March 2023',
    'April 2023',
    'May 2023',
    'June 2023',
    'July 2023',
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    // Define theme colors
    final primaryGreen = Color(0xFF2E7D32);
    final secondaryPurple = Color(0xFF6A1B9A);
    final lightGreen = Color(0xFF4CAF50);
    final lightPurple = Color(0xFF9C27B0);
    final bgColor = isDarkMode ? Color(0xFF0A1F0A) : Colors.white;
    final cardColor = isDarkMode ? Color(0xFF1A2F1A) : Colors.white;

    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            selectedIndex: _selectedIndex,
            onItemSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
              
              if (index == 1) {
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
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // App Logo and Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
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
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/app_logo.png',
                                    width: 30,
                                    height: 30,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Monthly Statistics',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: primaryGreen,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Overview of your shop\'s performance for the selected month',
                                    style: TextStyle(
                                      color: isDarkMode ? Colors.white70 : Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: primaryGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: primaryGreen.withOpacity(0.3)),
                            ),
                            child: DropdownButton<String>(
                              value: _selectedMonth,
                              items: _availableMonths.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    _selectedMonth = newValue;
                                  });
                                }
                              },
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              icon: Icon(Icons.keyboard_arrow_down, color: primaryGreen),
                              underline: Container(),
                              dropdownColor: isDarkMode ? Color(0xFF1A2F1A) : Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildMonthlyOverview(context, primaryGreen, secondaryPurple, cardColor, isDarkMode),
                      const SizedBox(height: 24),
                      _buildMonthlySalesChart(context, primaryGreen, cardColor, isDarkMode),
                      const SizedBox(height: 24),
                      if (isTablet)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _buildTopSellingProducts(context, primaryGreen, secondaryPurple, cardColor, isDarkMode)),
                            const SizedBox(width: 16),
                            Expanded(child: _buildCustomerGrowth(context, secondaryPurple, cardColor, isDarkMode)),
                          ],
                        )
                      else
                        Column(
                          children: [
                            _buildTopSellingProducts(context, primaryGreen, secondaryPurple, cardColor, isDarkMode),
                            const SizedBox(height: 24),
                            _buildCustomerGrowth(context, secondaryPurple, cardColor, isDarkMode),
                          ],
                        ),
                      const SizedBox(height: 24),
                      _buildCategorySales(context, primaryGreen, secondaryPurple, cardColor, isDarkMode),
                      const SizedBox(height: 24),
                      _buildMonthlyOrderStatus(context, primaryGreen, secondaryPurple, cardColor, isDarkMode),
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

  Widget _buildMonthlyOverview(BuildContext context, Color primaryGreen, Color secondaryPurple, Color cardColor, bool isDarkMode) {
    // Mock data for monthly statistics
    final stats = {
      'Total Revenue': '\$28,450.75',
      'Orders': '487',
      'Average Order': '\$58.42',
      'New Customers': '124',
    };
    
    final comparisonToPrevMonth = {
      'Total Revenue': 15.3,
      'Orders': 8.7,
      'Average Order': 6.2,
      'New Customers': 12.5,
    };
    
    final icons = {
      'Total Revenue': Icons.attach_money,
      'Orders': Icons.shopping_cart,
      'Average Order': Icons.receipt,
      'New Customers': Icons.people,
    };
    
    final colors = {
      'Total Revenue': primaryGreen,
      'Orders': secondaryPurple,
      'Average Order': Color(0xFFFF9800), // Orange
      'New Customers': Color(0xFF9C27B0), // Purple
    };
    
    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 900 ? 4 : 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: stats.keys.map((key) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: colors[key]!.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: colors[key]!.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colors[key]!.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icons[key],
                      color: colors[key],
                      size: 24,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: comparisonToPrevMonth[key]! >= 0 
                          ? primaryGreen.withOpacity(0.1) 
                          : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          comparisonToPrevMonth[key]! >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                          color: comparisonToPrevMonth[key]! >= 0 ? primaryGreen : Colors.red,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${comparisonToPrevMonth[key]!.abs().toStringAsFixed(1)}%',
                          style: TextStyle(
                            color: comparisonToPrevMonth[key]! >= 0 ? primaryGreen : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                stats[key]!,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colors[key],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                key,
                style: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMonthlySalesChart(BuildContext context, Color primaryGreen, Color cardColor, bool isDarkMode) {
    // Mock data for daily sales within the month
    final List<Map<String, dynamic>> dailySales = [
      {'day': '1', 'amount': 850.0},
      {'day': '5', 'amount': 920.0},
      {'day': '10', 'amount': 1050.0},
      {'day': '15', 'amount': 980.0},
      {'day': '20', 'amount': 1200.0},
      {'day': '25', 'amount': 1100.0},
      {'day': '30', 'amount': 1300.0},
    ];
    
    // Find the maximum value for scaling
    final double maxAmount = dailySales.map((e) => e['amount'] as double).reduce((a, b) => a > b ? a : b);
    
    return Container(
      height: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
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
            'Monthly Sales Trend',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryGreen,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Daily sales performance throughout $_selectedMonth',
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black54,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: dailySales.map((day) {
                // Calculate the height percentage based on the maximum value
                final double heightPercentage = (day['amount'] as double) / maxAmount;
                
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 180 * heightPercentage,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [primaryGreen, primaryGreen.withOpacity(0.7)],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          day['day'] as String,
                          style: TextStyle(
                            color: isDarkMode ? Colors.white70 : Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$${(day['amount'] as double).toStringAsFixed(0)}',
                          style: TextStyle(
                            color: primaryGreen,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSellingProducts(BuildContext context, Color primaryGreen, Color secondaryPurple, Color cardColor, bool isDarkMode) {
    // Mock data for top products in the month
    final List<Map<String, dynamic>> topProducts = [
      {
        'name': 'Organic Bananas',
        'image': 'assets/images/fruits.jpg',
        'quantity': 230,
        'revenue': '\$1,150.00',
      },
      {
        'name': 'Fresh Milk',
        'image': 'assets/images/placeholder.jpg',
        'quantity': 180,
        'revenue': '\$900.00',
      },
      {
        'name': 'Whole Wheat Bread',
        'image': 'assets/images/grains.jpg',
        'quantity': 150,
        'revenue': '\$750.00',
      },
      {
        'name': 'Chicken Breast',
        'image': 'assets/images/placeholder.jpg',
        'quantity': 120,
        'revenue': '\$600.00',
      },
      {
        'name': 'Mixed Nuts',
        'image': 'assets/images/nuts.jpg',
        'quantity': 100,
        'revenue': '\$500.00',
      },
    ];
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
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
            'Top Selling Products',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryGreen,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Best performing products in $_selectedMonth',
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black54,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          ...topProducts.map((product) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      product['image'] as String,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['name'] as String,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Sold: ${product['quantity']} units',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white70 : Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    product['revenue'] as String,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryGreen,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildCustomerGrowth(BuildContext context, Color secondaryPurple, Color cardColor, bool isDarkMode) {
    // Mock data for weekly customer acquisition within the month
    final List<Map<String, dynamic>> weeklyCustomers = [
      {'week': 'Week 1', 'customers': 32},
      {'week': 'Week 2', 'customers': 28},
      {'week': 'Week 3', 'customers': 35},
      {'week': 'Week 4', 'customers': 29},
    ];
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: secondaryPurple.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: secondaryPurple.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'New Customers',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: secondaryPurple,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Weekly customer acquisition in $_selectedMonth',
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black54,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 24),
          ...weeklyCustomers.map((week) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        week['week'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                      Text(
                        '${week['customers']} customers',
                        style: TextStyle(
                          color: secondaryPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: (week['customers'] as int) / 40, // Assuming 40 is the target
                      backgroundColor: isDarkMode ? Colors.white10 : Colors.black.withOpacity(0.05),
                      valueColor: AlwaysStoppedAnimation<Color>(secondaryPurple),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: secondaryPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: secondaryPurple.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.people,
                      color: secondaryPurple,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Total: 124 new customers',
                      style: TextStyle(
                        color: secondaryPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySales(BuildContext context, Color primaryGreen, Color secondaryPurple, Color cardColor, bool isDarkMode) {
    // Mock data for category sales in the month
    final List<Map<String, dynamic>> categorySales = [
      {'category': 'Fruits & Vegetables', 'percentage': 35, 'color': primaryGreen},
      {'category': 'Dairy & Eggs', 'percentage': 25, 'color': secondaryPurple},
      {'category': 'Meat & Seafood', 'percentage': 20, 'color': Color(0xFFFF9800)},
      {'category': 'Bakery', 'percentage': 12, 'color': Color(0xFF9C27B0)},
      {'category': 'Beverages', 'percentage': 8, 'color': Color(0xFFF44336)},
    ];
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
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
            'Sales by Category',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryGreen,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Distribution of sales across product categories in $_selectedMonth',
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black54,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              // Pie chart representation
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: primaryGreen.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: CustomPaint(
                  painter: PieChartPainter(
                    data: categorySales.map((e) => e['percentage'] as int).toList(),
                    colors: categorySales.map((e) => e['color'] as Color).toList(),
                    isDarkMode: isDarkMode,
                  ),
                ),
              ),
              const SizedBox(width: 24),
              // Legend
              Expanded(
                child: Column(
                  children: categorySales.map((category) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: category['color'] as Color,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: (category['color'] as Color).withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              category['category'] as String,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: isDarkMode ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: (category['color'] as Color).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: (category['color'] as Color).withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              '${category['percentage']}%',
                              style: TextStyle(
                                color: category['color'] as Color,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyOrderStatus(BuildContext context, Color primaryGreen, Color secondaryPurple, Color cardColor, bool isDarkMode) {
    // Mock data for order status in the month
    final Map<String, Map<String, dynamic>> orderStatus = {
      'Delivered': {
        'count': 385,
        'percentage': 79,
        'color': primaryGreen,
      },
      'Processing': {
        'count': 68,
        'percentage': 14,
        'color': secondaryPurple,
      },
      'Pending': {
        'count': 34,
        'percentage': 7,
        'color': Color(0xFFFF9800),
      },
    };
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
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
            'Order Status',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryGreen,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Distribution of order statuses in $_selectedMonth',
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black54,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: orderStatus.entries.map((entry) {
              return Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 90,
                        height: 90,
                        child: CircularProgressIndicator(
                          value: (entry.value['percentage'] as int) / 100,
                          strokeWidth: 10,
                          backgroundColor: isDarkMode ? Colors.white10 : Colors.black.withOpacity(0.05),
                          valueColor: AlwaysStoppedAnimation<Color>(entry.value['color'] as Color),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            '${entry.value['percentage']}%',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: entry.value['color'] as Color,
                            ),
                          ),
                          Text(
                            '${entry.value['count']}',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDarkMode ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    entry.key,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: entry.value['color'] as Color,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: primaryGreen.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart, color: primaryGreen),
                const SizedBox(width: 8),
                Text(
                  'Total Orders: 487',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: primaryGreen,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for pie chart
class PieChartPainter extends CustomPainter {
  final List<int> data;
  final List<Color> colors;
  final bool isDarkMode;

  PieChartPainter({
    required this.data,
    required this.colors,
    required this.isDarkMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final total = data.reduce((a, b) => a + b);
    final radius = size.width / 2;
    final center = Offset(size.width / 2, size.height / 2);
    
    double startAngle = -90 * (3.14159 / 180); // Start from the top (in radians)
    
    for (int i = 0; i < data.length; i++) {
      final sweepAngle = (data[i] / total) * 2 * 3.14159;
      
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.fill;
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );
      
      startAngle += sweepAngle;
    }
    
    // Draw a white circle in the center for a donut chart effect
    final centerPaint = Paint()
      ..color = isDarkMode ? Color(0xFF1A2F1A) : Colors.white
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, radius * 0.6, centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}