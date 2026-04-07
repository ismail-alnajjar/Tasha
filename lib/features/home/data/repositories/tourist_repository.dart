import 'package:dio/dio.dart';
import '../../../../core/services/api_service.dart';
import '../models/place_model.dart';

class TouristRepository {
  final ApiService _apiService = ApiService();

  Future<List<PlaceModel>> getTouristPlaces(String category) async {
    try {
      String endpoint;
      
      switch (category.toLowerCase()) {
        case 'museums':
          endpoint = 'tourist/places/museums';
          break;
        case 'popular':
          endpoint = 'tourist/places/popular';
          break;
        case 'nature':
          endpoint = 'tourist/places/nature';
          break;
        case 'dining':
        case 'food':
        case 'food-drink':
          endpoint = 'tourist/places/food-drink';
          break;
        case 'history':
        case 'heritage':
        case 'cultural':
          endpoint = 'tourist/places/history';
          break;
        case 'shopping':
          endpoint = 'tourist/places/shopping';
          break;
        default:
          endpoint = 'tourist/places';
      }

      print('DEBUG TOURIST: Requesting Tourist Places: $endpoint');
      final response = await _apiService.get(endpoint);

      if (response.statusCode == 200) {
        final rawData = response.data;
        List<dynamic> data = [];
        
        if (rawData is List) {
          data = rawData;
        } else if (rawData is Map) {
          data = rawData['items'] ?? rawData['data'] ?? rawData['places'] ?? rawData['results'] ?? [];
        }

        return data.map((json) => PlaceModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('ERROR TOURIST: Error fetching tourist places ($category): $e');
      if (e is DioException && e.response != null) {
        throw Exception('API Error: ${e.response?.statusCode} - ${e.response?.data}');
      }
      rethrow;
    }
  }
}
