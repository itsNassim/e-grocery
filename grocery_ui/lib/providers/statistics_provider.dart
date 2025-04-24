import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatisticsProvider with ChangeNotifier {
  bool _isLoading = false;
  String _selectedPeriod = 'This Month';

  bool get isLoading => _isLoading;
  String get selectedPeriod => _selectedPeriod;

  void setPeriod(String period) {
    _selectedPeriod = period;
    notifyListeners();
  }

  // Helper method to format currency
  String formatCurrency(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }
  
  // Helper method to format date
  String formatDate(DateTime date) {
    return DateFormat('MMM d').format(date);
  }
}