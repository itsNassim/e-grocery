// shopping_cart_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/classes/products_class.dart';
import 'package:user/classes/shopping_cart_class.dart';

class ShoppingCartState {
  final List<ShoppingCartItem> cartItems;
  ShoppingCartState(this.cartItems);
}

abstract class ShoppingCartEvent {}

class AddProduct extends ShoppingCartEvent {
  final ShoppingCartItem cartItem;
  AddProduct(this.cartItem);
}

class RemoveProduct extends ShoppingCartEvent {
  final ShoppingCartItem cartItem;
  RemoveProduct(this.cartItem);
}

class IncrementProduct extends ShoppingCartEvent {
  final Product product;
  IncrementProduct(this.product);
}

class DecrementProduct extends ShoppingCartEvent {
  final Product product;
  DecrementProduct(this.product);
}

class ShoppingCartBloc extends Bloc<ShoppingCartEvent, ShoppingCartState> {
  ShoppingCartBloc() : super(ShoppingCartState([])) {
    on<AddProduct>((event, emit) {
      final updated = List<ShoppingCartItem>.from(state.cartItems)
        ..add(event.cartItem);
      emit(ShoppingCartState(updated));
    });

    on<RemoveProduct>((event, emit) {
      final updated = List<ShoppingCartItem>.from(state.cartItems)
        ..remove(event.cartItem);
      emit(ShoppingCartState(updated));
    });

    on<IncrementProduct>((event, emit) {
      final updated = state.cartItems.map((item) {
        if (item.product == event.product) {
          return ShoppingCartItem(
              product: item.product, quantity: item.quantity + 1);
        }
        return item;
      }).toList();
      emit(ShoppingCartState(updated));
    });

    on<DecrementProduct>((event, emit) {
      final updated = state.cartItems
          .map((item) {
            if (item.product == event.product && item.quantity > 1) {
              return ShoppingCartItem(
                  product: item.product, quantity: item.quantity - 1);
            }
            return item;
          })
          .where((item) => item.quantity > 0)
          .toList();
      emit(ShoppingCartState(updated));
    });
  }
}
