import 'package:tashaapp/core/services/api_service.dart';
import 'package:tashaapp/features/home/data/models/offer_model.dart';
import 'package:dio/dio.dart';

class OfferRepository {
  final ApiService _apiService = ApiService();

  Future<List<OfferModel>> getOffers() async {
    try {
      final response = await _apiService.get('/CitizenFeatures/offers');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = response.data is List ? response.data : (response.data['data'] ?? response.data['offers'] ?? []);
        return data.map((json) => OfferModel.fromJson(json)).toList();
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
