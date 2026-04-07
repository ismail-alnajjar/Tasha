import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tashaapp/features/home/cubit/review_state.dart';
import 'package:tashaapp/features/home/data/repositories/review_repository.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final ReviewRepository _repository;
  
  ReviewCubit(this._repository) : super(ReviewInitial());

  Future<void> fetchReviews(int tripId) async {
    try {
      emit(ReviewLoading());
      final reviews = await _repository.getTripReviews(tripId);
      emit(ReviewLoaded(reviews));
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  Future<void> submitReview({
    required int tripId,
    required int rating,
    required String comment,
    String? firebaseUid,
    String? reviewerName,
  }) async {
    try {
      emit(ReviewSubmitting());
      
      await _repository.submitTripReview(
        tripId: tripId,
        rating: rating,
        comment: comment,
        firebaseUid: firebaseUid,
        reviewerName: reviewerName,
      );
      
      emit(ReviewSubmitted());
      
      // Reload reviews
      fetchReviews(tripId);
    } catch (e) {
      emit(ReviewSubmitError(e.toString()));
    }
  }
}
