import 'package:mahsoul_dz/core/api/api_client.dart';
import 'package:mahsoul_dz/core/api/api_endpoints.dart';
import 'package:mahsoul_dz/core/errors/api_exception.dart';
import 'package:mahsoul_dz/data/models/shared/review.dart';

class ReviewRepository {
  final ApiClient _apiClient;

  ReviewRepository(this._apiClient);

  /// Get all reviews for a product
  Future<List<ReviewModel>> getProductReviews(String productId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.productReviews(productId),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final reviews = data['reviews'] as List<dynamic>;
        return reviews
            .map((r) => ReviewModel.fromJson(r as Map<String, dynamic>))
            .toList();
      }
      throw ApiException('Failed to fetch reviews');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error fetching reviews: ${e.toString()}');
    }
  }

  /// Create a new review for a product
  Future<ReviewModel> createReview({
    required String productId,
    required String customerId,
    required double rating,
    required String comment,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.productReviews(productId),
        data: {
          'customer_id': customerId,
          'rating': rating,
          'comment': comment,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;
        return ReviewModel.fromJson(data['review'] as Map<String, dynamic>);
      }
      throw ApiException(
        response.data['error']?.toString() ?? 'Failed to create review',
      );
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error creating review: ${e.toString()}');
    }
  }

  /// Delete a review
  Future<void> deleteReview(String productId, String reviewId) async {
    try {
      final response = await _apiClient.delete(
        '${ApiEndpoints.productReviews(productId)}/$reviewId',
      );

      if (response.statusCode != 200) {
        throw ApiException(
          response.data['error']?.toString() ?? 'Failed to delete review',
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error deleting review: ${e.toString()}');
    }
  }
}
