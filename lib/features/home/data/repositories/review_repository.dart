import 'package:tashaapp/core/services/api_service.dart';
import 'package:tashaapp/features/home/data/models/review_model.dart';
import 'package:dio/dio.dart';

class ReviewRepository {
  final ApiService _apiService = ApiService();

  Future<List<ReviewModel>> getTripReviews(int tripId) async {
    try {
      final response = await _apiService.get('citizen/trips/$tripId/reviews');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['data'] != null) {
          final List<dynamic> reviewsData = data['data'];
          return reviewsData.map((e) => ReviewModel.fromJson(e)).toList();
        }
      }
      return [];
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 404) {
          return []; // Endpoint not found or no reviews exist
        }
        final errData = e.response?.data;
        if (errData is Map) {
          throw Exception(errData['message'] ?? e.message);
        }
        throw Exception(e.message);
      }
      throw Exception('Failed to fetch reviews: $e');
    }
  }

  Future<void> submitTripReview({
    required int tripId,
    required int rating,
    required String comment,
    String? firebaseUid,
    String? reviewerName,
  }) async {
    try {
      final payload = {
        "rating": rating,
        "comment": comment,
        "firebaseUid": firebaseUid ?? "anonymous",
        "reviewerName": reviewerName ?? "Citizen",
      };
      
      final response = await _apiService.post(
        'citizen/trips/$tripId/reviews',
        data: payload,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to submit review');
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 404) {
          throw Exception('The trip was not found (404), or the API endpoint path is incorrect.');
        }
        final errData = e.response?.data;
        if (errData is Map) {
          if (errData.containsKey('errors')) {
            throw Exception('Validation Errors: ${errData['errors']}');
          }
          throw Exception(errData['message'] ?? e.message);
        }
        throw Exception(e.message);
      }
      throw Exception('Failed to submit review: $e');
    }
  }
}
