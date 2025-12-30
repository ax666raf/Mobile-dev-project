import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mahsoul_dz/data/models/shared/review.dart';
import 'package:mahsoul_dz/data/repositories/review_repository.dart';
import 'package:mahsoul_dz/core/errors/api_exception.dart';
import 'package:mahsoul_dz/presentation/cubits/review/review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final ReviewRepository _repository;

  ReviewCubit(this._repository) : super(ReviewInitial());

  /// Load all reviews for a product
  Future<void> loadReviews(String productId) async {
    emit(ReviewLoading());

    try {
      final reviews = await _repository.getProductReviews(productId);
      
      // Calculate average rating
      double avgRating = 0.0;
      if (reviews.isNotEmpty) {
        final totalRating = reviews.fold<double>(
          0.0,
          (sum, review) => sum + review.rating,
        );
        avgRating = totalRating / reviews.length;
      }

      emit(ReviewLoaded(reviews, avgRating, reviews.length));
    } on ApiException catch (e) {
      emit(ReviewError(e.message));
    } catch (e) {
      emit(ReviewError('Failed to load reviews: ${e.toString()}'));
    }
  }

  /// Submit a new review
  Future<void> submitReview({
    required String productId,
    required String customerId,
    required double rating,
    required String comment,
  }) async {
    emit(ReviewSubmitting());

    try {
      final review = await _repository.createReview(
        productId: productId,
        customerId: customerId,
        rating: rating,
        comment: comment,
      );

      emit(ReviewSubmitted(review, 'Review submitted successfully'));
      
      // Reload reviews after submission
      await loadReviews(productId);
    } on ApiException catch (e) {
      emit(ReviewError(e.message));
    } catch (e) {
      emit(ReviewError('Failed to submit review: ${e.toString()}'));
    }
  }

  /// Delete a review
  Future<void> deleteReview(String productId, String reviewId) async {
    try {
      await _repository.deleteReview(productId, reviewId);
      
      // Reload reviews after deletion
      await loadReviews(productId);
    } on ApiException catch (e) {
      emit(ReviewError(e.message));
    } catch (e) {
      emit(ReviewError('Failed to delete review: ${e.toString()}'));
    }
  }

  /// Check if user has already reviewed this product
  bool hasUserReviewed(String customerId) {
    if (state is ReviewLoaded) {
      final loadedState = state as ReviewLoaded;
      return loadedState.reviews.any((r) => r.customerId == customerId);
    }
    return false;
  }

  /// Get user's existing review if any
  ReviewModel? getUserReview(String customerId) {
    if (state is ReviewLoaded) {
      final loadedState = state as ReviewLoaded;
      try {
        return loadedState.reviews.firstWhere((r) => r.customerId == customerId);
      } catch (_) {
        return null;
      }
    }
    return null;
  }
}
