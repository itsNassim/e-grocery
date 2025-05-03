import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/backend/category/category.dart';
import 'package:user/backend/product/product.dart';
import 'package:user/backend/store/store.dart';
import 'package:user/classes/category_class.dart';
import 'package:user/classes/products_class.dart';
import 'package:user/classes/shop_class.dart';

// Events
abstract class DataEvent {}

class LoadDataEvent extends DataEvent {}

// States
abstract class DataState {}

class DataLoadingState extends DataState {}

class DataLoadedState extends DataState {
  final List<Category> categories;
  final List<ShopClass> stores;
  final List<Product> products;

  DataLoadedState({
    required this.categories,
    required this.stores,
    required this.products,
  });
}

class DataErrorState extends DataState {
  final String errorMessage;

  DataErrorState({required this.errorMessage});
}

class DataBloc extends Bloc<DataEvent, DataState> {
  DataBloc() : super(DataLoadingState()) {
    on<LoadDataEvent>((event, emit) async {
      try {
        final categories = await fetchCategories();
        final stores = await fetchStores();
        final products = await fetchProducts();

        emit(DataLoadedState(
          categories: categories,
          stores: stores,
          products: products,
        ));
      } catch (e) {
        emit(DataErrorState(errorMessage: e.toString()));
      }
    });
  }
}
