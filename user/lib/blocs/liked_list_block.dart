import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/backend/likesList/like_list.dart';
import 'package:user/classes/likesList_class.dart';
import 'package:user/classes/products_class.dart';

// EVENTS
abstract class LikeslistEvent {}

class AddProductEvent extends LikeslistEvent {
  final Product product;
  final Likeslist likeslist;

  AddProductEvent(this.product, this.likeslist);
}

class RemoveProductEvent extends LikeslistEvent {
  final Product product;
  final Likeslist likeslist;

  RemoveProductEvent(this.product, this.likeslist);
}

class AddLikesListEvent extends LikeslistEvent {
  final String title;

  AddLikesListEvent(this.title);
}

class RemoveLikesListEvent extends LikeslistEvent {
  final Likeslist likeslist;

  RemoveLikesListEvent(this.likeslist);
}

class RefreshLikesLists extends LikeslistEvent {}

// STATES
class LikeslistState {
  final List<Likeslist> likeslists;

  LikeslistState({required this.likeslists});
}

// BLOC
class LikeslistBloc extends Bloc<LikeslistEvent, LikeslistState> {
  final LikeslistApiService apiService;

  LikeslistBloc({required this.apiService})
      : super(LikeslistState(likeslists: [])) {
    on<AddProductEvent>(_onAddProduct);
    on<RemoveProductEvent>(_onRemoveProduct);
    on<AddLikesListEvent>(_onAddLikesList);
    on<RemoveLikesListEvent>(_onRemoveLikesList);
    on<RefreshLikesLists>(_onRefreshLikesLists);

    // Initial load
    add(RefreshLikesLists());
  }

  Future<void> _onAddProduct(
      AddProductEvent event, Emitter<LikeslistState> emit) async {
    try {
      await apiService.addProductToList(
          event.likeslist.id, int.parse(event.product.id));
      final lists = await apiService.fetchLikeslists();
      emit(LikeslistState(likeslists: lists));
    } catch (e) {
      emit(LikeslistState(likeslists: state.likeslists));
    }
  }

  Future<void> _onRemoveProduct(
      RemoveProductEvent event, Emitter<LikeslistState> emit) async {
    try {
      await apiService.removeProductFromList(
          event.likeslist.id, int.parse(event.product.id));
      final lists = await apiService.fetchLikeslists();
      emit(LikeslistState(likeslists: lists));
    } catch (e) {
      emit(LikeslistState(likeslists: state.likeslists));
    }
  }

  Future<void> _onAddLikesList(
      AddLikesListEvent event, Emitter<LikeslistState> emit) async {
    try {
      await apiService.addLikeslist(event.title);
      final lists = await apiService.fetchLikeslists();
      emit(LikeslistState(likeslists: lists));
    } catch (e) {
      emit(LikeslistState(likeslists: state.likeslists));
    }
  }

  Future<void> _onRemoveLikesList(
      RemoveLikesListEvent event, Emitter<LikeslistState> emit) async {
    try {
      await apiService.removeLikeslist(event.likeslist.id);
      final lists = await apiService.fetchLikeslists();
      emit(LikeslistState(likeslists: lists));
    } catch (e) {
      emit(LikeslistState(likeslists: state.likeslists));
    }
  }

  Future<void> _onRefreshLikesLists(
      RefreshLikesLists event, Emitter<LikeslistState> emit) async {
    try {
      final lists = await apiService.fetchLikeslists();
      if (lists.isEmpty) {
        print('the lists is empty');
      } else {
        print("have content");
      }
      emit(LikeslistState(likeslists: lists));
    } catch (e) {
      print("$e");
      emit(LikeslistState(likeslists: []));
    }
  }
}
