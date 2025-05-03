import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:user/Pages/main_page.dart';
import 'package:user/Pages/onboreding/onboarding_page.dart';
import 'package:user/authuntication/log_in.dart';
import 'package:user/backend/likesList/like_list.dart';
import 'package:user/backend/shopping_cart/shopping_cart.dart';
import 'package:user/backend/store/review.dart';
import 'package:user/blocs/data_bloc.dart';
import 'package:user/blocs/liked_list_block.dart';
import 'package:user/blocs/liked_stores_bloc.dart';
import 'package:user/blocs/review_bloc.dart';
import 'package:user/blocs/shopping_cart_bloc.dart';
import 'Pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();


  await Hive.openBox("mybox");

  final cartApiService = await CartApiService.create();
  final likeslistApiService = await LikeslistApiService.create();

  runApp(MyApp(
    cartApiService: cartApiService,
    likeslistApiService: likeslistApiService,
  ));
}

class MyApp extends StatelessWidget {
  final CartApiService cartApiService;
  final LikeslistApiService likeslistApiService;
  MyApp({
    super.key,
    required this.cartApiService,
    required this.likeslistApiService,
  });

  @override
  Widget build(BuildContext context) {
    var box = Hive.box("mybox");
    bool? onboarding = box.get("onboarding");
    var token = box.get("token");
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => DataBloc()),
        BlocProvider(create: (_) => ShoppingCartBloc(cartApiService)),
        BlocProvider(
            create: (_) => LikeslistBloc(apiService: likeslistApiService)),
        BlocProvider(create: (_) => LikedStoresBloc()),
        BlocProvider(
            create: (_) => ReviewBloc(reviewRepository: ReviewRepository())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF013033)),
          useMaterial3: true,
        ),
        home: onboarding == null
            ? OnboardingPage()
            : token == null
                ? LogInPage()
                : MainPage(),
      ),
    );
  }
}
