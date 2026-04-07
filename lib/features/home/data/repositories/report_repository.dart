import 'package:dio/dio.dart';
import '../../../../core/services/api_service.dart';
import '../models/report_model.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

class ReportRepository {
  final ApiService _apiService = ApiService();

  Future<void> sendReport({
    required String title,
    required String description,
    required double latitude,
    required double longitude,
    List<File>? photos,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      Map<String, dynamic> data = {
        'Title': title,
        'Description': description,
        'Location': '$latitude,$longitude', // Swagger expects a single 'Location' string
        'FirebaseUid': user?.uid ?? '',
        'ReporterName': user?.displayName ?? 'Customer',
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

      await _apiService.postFormData('CitizenFeatures/issue-reports', formData);
    } catch (e) {
      if (e is DioException && e.response != null) {
        throw Exception(e.response?.data.toString());
      }
      rethrow;
    }
  }

  Future<List<ReportModel>> getMyReports() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final response = await _apiService.get(
        'CitizenFeatures/issue-reports',
        queryParameters: {
          'firebaseUid': user?.uid ?? '',
        },
      );
      
      print('=== 🚀 مسار جلب البلاغات نجح 🚀 ===');
      print(response.data);

      if (response.statusCode == 200) {
        final rawData = response.data;
        List<dynamic> data = [];
        if (rawData is List) {
          data = rawData;
        } else if (rawData is Map) {
          data = rawData['items'] ?? rawData['data'] ?? rawData['reports'] ?? [];
        }
        return data.map((json) => ReportModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }
}
