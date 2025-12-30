import 'package:mahsoul_dz/data/models/shared/review.dart';

abstract class ReviewState {}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewLoaded extends ReviewState {
  final List<ReviewModel> reviews;
  final double averageRating;
  final int totalCount;

  ReviewLoaded(this.reviews, this.averageRating, this.totalCount);
}

class ReviewSubmitting extends ReviewState {}

class ReviewSubmitted extends ReviewState {
  final ReviewModel review;
  final String message;

  ReviewSubmitted(this.review, this.message);
}

class ReviewError extends ReviewState {
  final String message;

  ReviewError(this.message);
}
