import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/services/api_service.dart';

class LocalHostRepository {
  final ApiService _apiService = ApiService();

  Future<void> createLocalHost({
    required String title,
    required String description,
    required String citizenPhone,
    required String city,
    required String activities,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    
    final Map<String, dynamic> data = {
      'title': title,
      'description': description,
      'citizenPhone': citizenPhone,
      'city': city,
      'activities': activities,
      'citizenUserId': user?.uid ?? '',
      'citizenName': user?.displayName ?? 'Local Host',
    };

    await _apiService.post('/CitizenFeatures/local-hosts', data: data);
  }
}
