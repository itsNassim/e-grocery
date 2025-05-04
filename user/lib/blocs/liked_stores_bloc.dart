import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:user/backend/store/liked_stores.dart';
import 'dart:convert';
import 'package:user/classes/shop_class.dart';

/// Events
abstract class LikedStoresEvent {}

class FetchLikedStoresEvent extends LikedStoresEvent {}

class AddLikedStoreEvent extends LikedStoresEvent {
  final ShopClass store;
  AddLikedStoreEvent(this.store);
}

class RemoveLikedStoreEvent extends LikedStoresEvent {
  final ShopClass store;
  RemoveLikedStoreEvent(this.store);
}

// States
class LikedStoresState {
  final List<ShopClass> shopsList;

  LikedStoresState({
    this.shopsList = const [],
  });

  LikedStoresState copyWith({
    List<ShopClass>? shopsList,
  }) {
    return LikedStoresState(
      shopsList: shopsList ?? this.shopsList,
    );
  }
}

// Bloc
class LikedStoresBloc extends Bloc<LikedStoresEvent, LikedStoresState> {
  LikedStoresBloc() : super(LikedStoresState()) {
    on<FetchLikedStoresEvent>(_onFetchLikedStores);
    on<AddLikedStoreEvent>(_onAddLikedStore);
    on<RemoveLikedStoreEvent>(_onRemoveLikedStore);
  }

  Future<void> _onFetchLikedStores(
    FetchLikedStoresEvent event,
    Emitter<LikedStoresState> emit,
  ) async {
    try {
      final likedStores = await fetchLikedStores();
      emit(state.copyWith(shopsList: likedStores));
    } catch (e) {
      emit(state);
    }
  }

  Future<void> _onAddLikedStore(
    AddLikedStoreEvent event,
    Emitter<LikedStoresState> emit,
  ) async {
    try {
      await addStoreToLiked(event.store.id);
      final updatedStores = List<ShopClass>.from(state.shopsList)
        ..add(event.store);
      emit(state.copyWith(shopsList: updatedStores));
    } catch (e) {
      emit(state);
    }
  }

  Future<void> _onRemoveLikedStore(
    RemoveLikedStoreEvent event,
    Emitter<LikedStoresState> emit,
  ) async {
    try {
      await removeStoreFromLiked(event.store.id);
      add(FetchLikedStoresEvent());
    } catch (e) {
      emit(state);
    }
  }
}
