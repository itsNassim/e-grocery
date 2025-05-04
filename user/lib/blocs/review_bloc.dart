import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/backend/store/review.dart';
import 'package:user/classes/review_class.dart';

abstract class ReviewEvent {}

class FetchReviewsEvent extends ReviewEvent {
  final int storeId;
  FetchReviewsEvent(this.storeId);
}

class AddReviewEvent extends ReviewEvent {
  final int storeId;
  final String text;
  final int rating;
  AddReviewEvent(
    this.storeId,
    this.text,
    this.rating,
  );
}

class RemoveReviewEvent extends ReviewEvent {
  final int storeId;
  final int reviewId;
  RemoveReviewEvent(this.storeId, this.reviewId);
}

abstract class ReviewState {}

class ReviewInitialState extends ReviewState {}

class ReviewLoadingState extends ReviewState {}

class ReviewLoadedState extends ReviewState {
  final List<Review> reviews;
  ReviewLoadedState(this.reviews);
}

class ReviewErrorState extends ReviewState {
  final String errorMessage;
  ReviewErrorState(this.errorMessage);
}

class ReviewAddedState extends ReviewState {
  final Review review;
  ReviewAddedState(this.review);
}

class ReviewRemovedState extends ReviewState {
  final int reviewId;
  ReviewRemovedState(this.reviewId);
}

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRepository reviewRepository;

  ReviewBloc({required this.reviewRepository}) : super(ReviewInitialState()) {
    on<FetchReviewsEvent>(_onFetchReviewsEvent);
    on<AddReviewEvent>(_onAddReviewEvent);
    on<RemoveReviewEvent>(_onRemoveReviewEvent);
  }

  // Fetch reviews for a store
  Future<void> _onFetchReviewsEvent(
      FetchReviewsEvent event, Emitter<ReviewState> emit) async {
    try {
      final reviews = await reviewRepository.fetchReviews(event.storeId);
      emit(ReviewLoadedState(reviews));
    } catch (e) {
      emit(ReviewErrorState('Error fetching reviews'));
    }
  }

  // Add a new review
  Future<void> _onAddReviewEvent(
      AddReviewEvent event, Emitter<ReviewState> emit) async {
    emit(ReviewLoadingState());
    try {
      final review = await reviewRepository.addReview(
        event.storeId,
        event.text,
        event.rating,
      );
      add(FetchReviewsEvent(event.storeId));
      emit(ReviewAddedState(review));
    } catch (e) {
      print(e);
      emit(ReviewErrorState('Error adding review'));
    }
  }

  // Remove a review
  Future<void> _onRemoveReviewEvent(
      RemoveReviewEvent event, Emitter<ReviewState> emit) async {
    emit(ReviewLoadingState());
    try {
      await reviewRepository.removeReview(event.storeId, event.reviewId);
      add(FetchReviewsEvent(event.storeId));
      emit(ReviewRemovedState(event.reviewId));
    } catch (e) {
      emit(ReviewErrorState('Error removing review'));
    }
  }
}
