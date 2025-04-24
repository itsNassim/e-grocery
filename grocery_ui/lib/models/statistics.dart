class ShopStatistics {
  final double totalSales;
  final int totalOrders;
  final double revenueGrowth;
  final int newCustomers;
  final double averageOrderValue;
  final List<CategorySales> categorySales;
  final List<DailySales> dailySales;
  final List<ProductSales> topProducts;
  final List<PaymentMethodStats> paymentMethods;

  ShopStatistics({
    required this.totalSales,
    required this.totalOrders,
    required this.revenueGrowth,
    required this.newCustomers,
    required this.averageOrderValue,
    required this.categorySales,
    required this.dailySales,
    required this.topProducts,
    required this.paymentMethods,
  });
}

class CategorySales {
  final String category;
  final double amount;
  final double percentage;

  CategorySales({
    required this.category,
    required this.amount,
    required this.percentage,
  });
}

class DailySales {
  final DateTime date;
  final double amount;
  final int orders;

  DailySales({
    required this.date,
    required this.amount,
    required this.orders,
  });
}

class ProductSales {
  final String productId;
  final String productName;
  final String imageUrl;
  final int quantity;
  final double amount;

  ProductSales({
    required this.productId,
    required this.productName,
    required this.imageUrl,
    required this.quantity,
    required this.amount,
  });
}

class PaymentMethodStats {
  final String method;
  final double amount;
  final double percentage;

  PaymentMethodStats({
    required this.method,
    required this.amount,
    required this.percentage,
  });
}