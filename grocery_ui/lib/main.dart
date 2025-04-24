import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'screens/dashboard_screen.dart';
import 'screens/product_list_screen.dart';
import 'screens/order_list_screen.dart';
import 'screens/edit_product_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/order_detail_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/auth/sign_in_screen.dart';
import 'screens/auth/sign_up_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'providers/theme_provider.dart';
import 'providers/product_provider.dart';
import 'providers/order_provider.dart';
import 'providers/shopkeeper_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/statistics_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => ShopkeeperProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => StatisticsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grocery Admin Panel',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0E21),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0A0E21),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      themeMode: themeProvider.themeMode,
      home:
          authProvider.isAuthenticated ? const DashboardScreen() : const SignInScreen(),
      routes: {
        '/dashboard': (ctx) => const DashboardScreen(),
        '/products': (ctx) => const ProductListScreen(),
        '/orders': (ctx) => const OrderListScreen(),
        '/edit-product': (ctx) => const EditProductScreen(),
        '/profile': (ctx) => const ProfileScreen(),
        SignInScreen.routeName: (ctx) => const SignInScreen(),
        SignUpScreen.routeName: (ctx) => const SignUpScreen(),
        ForgotPasswordScreen.routeName: (ctx) => const ForgotPasswordScreen(),
        
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/product-detail') {
          final productId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (ctx) => ProductDetailScreen(productId: productId),
          );
        } else if (settings.name == '/order-detail') {
          final orderId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (ctx) => const OrderDetailScreen(),
            settings: RouteSettings(arguments: orderId),
          );
        }
        return null;
      },
    );
  }
}