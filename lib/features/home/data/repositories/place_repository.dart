import 'package:dio/dio.dart';
import '../../../../core/services/api_service.dart';
import '../models/place_model.dart';

class PlaceRepository {
  final ApiService _apiService = ApiService();

  Future<List<PlaceModel>> getPlacesByCategory(String category) async {
    try {
      // Default: use the label as-is or lowercased based on common API patterns
      // Explicitly follow the user's screenshot for each category
      String pathSegment = category.toLowerCase();
      if (category == 'Foodie') pathSegment = 'dining';
      
      final String fullUrlPath = 'citizen/places/$pathSegment';
      print('DEBUG: Requesting Places category: "$category" via $fullUrlPath');
      
      final response = await _apiService.get(fullUrlPath);
      print('DEBUG: Received response for "$category": Status ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final rawData = response.data;
        print('DEBUG: Raw Data from Places API: $rawData');
        
        List<dynamic> data = [];
        if (rawData is List) {
          data = rawData;
        } else if (rawData is Map) {
          data = rawData['items'] ?? rawData['data'] ?? rawData['places'] ?? rawData['results'] ?? [];
        }
        
        final result = data.map((json) => PlaceModel.fromJson(json)).toList();
        print('DEBUG: Successfully parsed ${result.length} places.');
        return result;
      }
      return [];
    } catch (e) {
      print('ERROR in PlaceRepository (category: $category): $e');
      if (e is DioException && e.response != null) {
        print('ERROR Response Data: ${e.response?.data}');
        throw Exception('API Error: ${e.response?.statusCode} - ${e.response?.data}');
      }
      rethrow;
    }
  }
}
