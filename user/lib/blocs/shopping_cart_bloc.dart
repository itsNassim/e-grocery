// shopping_cart_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/backend/shopping_cart/shopping_cart.dart';
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

class ClearCartEvent extends ShoppingCartEvent {}

class RefreshCart extends ShoppingCartEvent {}

class ShoppingCartBloc extends Bloc<ShoppingCartEvent, ShoppingCartState> {
  final CartApiService apiService;

  ShoppingCartBloc(this.apiService) : super(ShoppingCartState([])) {
    on<AddProduct>((event, emit) async {
      try {
        await apiService.addToCart(
            event.cartItem.product.id, event.cartItem.quantity);
        add(RefreshCart());
      } catch (e) {
        print("Error adding product: $e");
      }
    });

    on<RemoveProduct>((event, emit) async {
      try {
        await apiService.removeFromCart(event.cartItem.product.id);
        add(RefreshCart());
      } catch (e) {
        print("Error removing product: $e");
      }
    });

    on<IncrementProduct>((event, emit) async {
      try {
        final item =
            state.cartItems.firstWhere((i) => i.product.id == event.product.id);
        await apiService.updateQuantity(event.product.id, item.quantity + 1);
        add(RefreshCart());
      } catch (e) {
        print("Error incrementing product: $e");
      }
    });

    on<DecrementProduct>((event, emit) async {
      try {
        final item =
            state.cartItems.firstWhere((i) => i.product.id == event.product.id);
        if (item.quantity > 1) {
          await apiService.updateQuantity(event.product.id, item.quantity - 1);
          add(RefreshCart());
        } else {
          await apiService.removeFromCart(event.product.id);
          add(RefreshCart());
        }
      } catch (e) {
        print("Error decrementing product: $e");
      }
    });

    on<ClearCartEvent>((event, emit) async {
      try {
        await apiService.clearCart();
        emit(ShoppingCartState([]));
      } catch (e) {
        print("Error clearing cart: $e");
      }
    });

    on<RefreshCart>((event, emit) async {
      try {
        final items = await apiService.fetchCart();
        emit(ShoppingCartState(items));
      } catch (e, stackTrace) {
        print("Error loading cart: $e");
        print("Stack trace:\n$stackTrace");
      }
    });
  }
}
