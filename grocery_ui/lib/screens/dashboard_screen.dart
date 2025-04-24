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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 24),
                    _buildMonthlyOverview(context),
                    const SizedBox(height: 24),
                    _buildMonthlySalesChart(context),
                    const SizedBox(height: 24),
                    if (isTablet)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildTopSellingProducts(context)),
                          const SizedBox(width: 16),
                          Expanded(child: _buildCustomerGrowth(context)),
                        ],
                      )
                    else
                      Column(
                        children: [
                          _buildTopSellingProducts(context),
                          const SizedBox(height: 24),
                          _buildCustomerGrowth(context),
                        ],
                      ),
                    const SizedBox(height: 24),
                    _buildCategorySales(context),
                    const SizedBox(height: 24),
                    _buildMonthlyOrderStatus(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Monthly Statistics',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Overview of your shop\'s performance for the selected month',
              style: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
        DropdownButton<String>(
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
          ),
          icon: const Icon(Icons.keyboard_arrow_down),
          underline: Container(
            height: 2,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyOverview(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
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
      'Total Revenue': Colors.green,
      'Orders': Colors.blue,
      'Average Order': Colors.orange,
      'New Customers': Colors.purple,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colors[key]!.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icons[key],
                      color: colors[key],
                      size: 24,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        comparisonToPrevMonth[key]! >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                        color: comparisonToPrevMonth[key]! >= 0 ? Colors.green : Colors.red,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${comparisonToPrevMonth[key]!.abs().toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: comparisonToPrevMonth[key]! >= 0 ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Text(
                stats[key]!,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
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

  Widget _buildMonthlySalesChart(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
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
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Monthly Sales Trend',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
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
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(4),
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
                            color: isDarkMode ? Colors.white : Colors.black,
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

  Widget _buildTopSellingProducts(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
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
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Selling Products',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
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
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      product['image'] as String,
                      width: 40,
                      height: 40,
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
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
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
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
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

  Widget _buildCustomerGrowth(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Mock data for weekly customer acquisition within the month
    final List<Map<String, dynamic>> weeklyCustomers = [
      {'week': 'Week 1', 'customers': 32},
      {'week': 'Week 2', 'customers': 28},
      {'week': 'Week 3', 'customers': 35},
      {'week': 'Week 4', 'customers': 29},
    ];
    
    return Container(
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'New Customers',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
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
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${week['customers']} customers',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (week['customers'] as int) / 40, // Assuming 40 is the target
                      backgroundColor: isDarkMode ? Colors.white10 : Colors.black.withOpacity(0.05),
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.people,
                      color: Colors.blue,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Total: 124 new customers',
                      style: const TextStyle(
                        color: Colors.blue,
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

  Widget _buildCategorySales(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Mock data for category sales in the month
    final List<Map<String, dynamic>> categorySales = [
      {'category': 'Fruits & Vegetables', 'percentage': 35, 'color': Colors.blue},
      {'category': 'Dairy & Eggs', 'percentage': 25, 'color': Colors.green},
      {'category': 'Meat & Seafood', 'percentage': 20, 'color': Colors.orange},
      {'category': 'Bakery', 'percentage': 12, 'color': Colors.purple},
      {'category': 'Beverages', 'percentage': 8, 'color': Colors.red},
    ];
    
    return Container(
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sales by Category',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
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
              SizedBox(
                width: 120,
                height: 120,
                child: CustomPaint(
                  painter: PieChartPainter(
                    data: categorySales.map((e) => e['percentage'] as int).toList(),
                    colors: categorySales.map((e) => e['color'] as Color).toList(),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              // Legend
              Expanded(
                child: Column(
                  children: categorySales.map((category) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: category['color'] as Color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              category['category'] as String,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            '${category['percentage']}%',
                            style: TextStyle(
                              color: category['color'] as Color,
                              fontWeight: FontWeight.bold,
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

  Widget _buildMonthlyOrderStatus(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Mock data for order status in the month
    final Map<String, Map<String, dynamic>> orderStatus = {
      'Delivered': {
        'count': 385,
        'percentage': 79,
        'color': Colors.green,
      },
      'Processing': {
        'count': 68,
        'percentage': 14,
        'color': Colors.blue,
      },
      'Pending': {
        'count': 34,
        'percentage': 7,
        'color': Colors.orange,
      },
    };
    
    return Container(
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Status',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
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
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(
                          value: (entry.value['percentage'] as int) / 100,
                          strokeWidth: 8,
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
                              fontSize: 16,
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
                  const SizedBox(height: 12),
                  Text(
                    entry.key,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
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
              color: isDarkMode ? Colors.white10 : Colors.black.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.shopping_cart),
                const SizedBox(width: 8),
                Text(
                  'Total Orders: 487',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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

  PieChartPainter({
    required this.data,
    required this.colors,
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
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, radius * 0.6, centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}