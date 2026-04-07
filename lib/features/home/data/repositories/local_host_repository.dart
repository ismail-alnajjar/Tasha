import 'package:firebase_auth/firebase_auth.dart';
import 'package:dio/dio.dart';
import 'package:tashaapp/features/home/data/models/local_host_model.dart';
import '../../../../core/services/api_service.dart';

class LocalHostRepository {
  final ApiService _apiService = ApiService();

  Future<void> createLocalHost({
    required String title,
    required String description,
    required String citizenPhone,
    required String city,
    required String activities,
    required double latitude,
    required double longitude,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    
    final Map<String, dynamic> data = {
      'title': title,
      'description': description,
      'citizenPhone': citizenPhone,
      'city': city,
      'activities': activities,
      'latitude': latitude,
      'longitude': longitude,
      'citizenUserId': user?.uid ?? '',
      'citizenName': user?.displayName ?? 'Local Host',
    };

    await _apiService.post('CitizenFeatures/local-hosts', data: data);
  }

  Future<List<LocalHostModel>> getMyLocalHosts() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return [];
      
      // نرسلها كـ Query Parameter باسم firebaseUid أو citizenUserId ليتعامل معها السيرفر أو نتجاهلها إذا كان يعتمد على الـ Token
      final response = await _apiService.get(
        'CitizenFeatures/local-hosts/my',
        queryParameters: {
          'firebaseUid': user.uid,
          'citizenUserId': user.uid,
        },
      );
      
      print('🔍 My Local Hosts API Response: ${response.data}');
      
      final rawData = response.data;
      if (rawData != null && rawData is List) {
        return rawData.map((e) => LocalHostModel.fromJson(e)).toList();
      } else if (rawData != null && rawData is Map) {
         final list = rawData['items'] ?? rawData['data'] ?? [];
         return (list as List).map((e) => LocalHostModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      if (e is DioException && e.response != null) {
        print('❌ My Local Hosts Error: ${e.response?.data}');
      }
      rethrow;
    }
  }

  Future<List<LocalHostModel>> getAllLocalHosts() async {
    try {
      final response = await _apiService.get('CitizenFeatures/local-hosts');
      print('🔍 Raw All Local Hosts Response: ${response.data}');
      
      final rawData = response.data;
      if (rawData != null && rawData is List) {
        return rawData.map((e) => LocalHostModel.fromJson(e)).toList();
      } else if (rawData != null && rawData is Map) {
        final list = rawData['data'] ?? rawData['items'] ?? rawData['hosts'] ?? [];
        return (list as List).map((e) => LocalHostModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print('❌ Error in getAllLocalHosts: $e');
      return [];
    }
  }

  Future<void> replyToLocalHost({
    required int id,
    required String status,
    required String adminReply,
  }) async {
    final Map<String, dynamic> data = {
      'status': status, // 'Approved' or 'Rejected'
      'adminReply': adminReply,
    };
    
    // استخدام POST للرد كما طلبت
    await _apiService.post('CitizenFeatures/local-hosts/$id/reply', data: data);
  }
}
