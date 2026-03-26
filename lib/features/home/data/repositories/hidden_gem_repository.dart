import 'package:dio/dio.dart';
import '../../../../core/services/api_service.dart';
import '../models/hidden_gem_model.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

class HiddenGemRepository {
  final ApiService _apiService = ApiService();

  Future<void> sendHiddenGem({
    required String name,
    required String description,
    required double latitude,
    required double longitude,
    List<File>? photos,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      Map<String, dynamic> data = {
        'Name': name,
        'Description': description,
        'Latitude': latitude,
        'Longitude': longitude,
        'FirebaseUid': user?.uid ?? '',
        'CitizenName': user?.displayName ?? 'Customer',
      };

      FormData formData = FormData.fromMap(data);

      if (photos != null && photos.isNotEmpty) {
        for (var photo in photos) {
          formData.files.add(MapEntry(
            'Photos',
            await MultipartFile.fromFile(photo.path, filename: photo.path.split('/').last),
          ));
        }
      }

      await _apiService.postFormData('/CitizenFeatures/hidden-gems', formData);
    } catch (e) {
      if (e is DioException && e.response != null) {
        throw Exception(e.response?.data.toString());
      }
      rethrow;
    }
  }

  Future<List<HiddenGemModel>> getMyHiddenGems() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final response = await _apiService.get(
        '/CitizenFeatures/hidden-gems',
        queryParameters: {
          'firebaseUid': user?.uid ?? '',
        },
      );
      
      if (response.statusCode == 200) {
        final rawData = response.data;
        List<dynamic> data = [];
        if (rawData is List) {
          data = rawData;
        } else if (rawData is Map) {
          data = rawData['items'] ?? rawData['data'] ?? [];
        }
        return data.map((json) => HiddenGemModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }
}
