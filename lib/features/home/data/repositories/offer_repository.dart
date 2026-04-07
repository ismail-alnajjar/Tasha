import 'package:tashaapp/core/services/api_service.dart';
import 'package:tashaapp/features/home/data/models/offer_model.dart';
import 'package:dio/dio.dart';

class OfferRepository {
  final ApiService _apiService = ApiService();

  Future<List<OfferModel>> getOffers() async {
    try {
      final response = await _apiService.get('CitizenFeatures/offers');
      print('=== 🚀 مسار جلب العروض 🚀 ===');
      print('DEBUG: Offers raw data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final rawData = response.data;
        List<dynamic> data = [];
        if (rawData is List) {
          data = rawData;
        } else if (rawData is Map) {
          data = rawData['data'] ?? rawData['offers'] ?? rawData['items'] ?? [];
        }
        return data.map((json) => OfferModel.fromJson(json is Map<String, dynamic> ? json : {})).toList();
      } else {
        throw Exception('Failed to load offers');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message ?? 'Unknown error');
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
