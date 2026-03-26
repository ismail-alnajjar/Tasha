import 'package:equatable/equatable.dart';

class HiddenGemModel extends Equatable {
  final String? id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final List<String> photoUrls;
  final String? status;
  final DateTime? createdAt;
  final String? adminReply;

  const HiddenGemModel({
    this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    this.photoUrls = const [],
    this.status,
    this.createdAt,
    this.adminReply,
  });

  factory HiddenGemModel.fromJson(Map<String, dynamic> json) {
    return HiddenGemModel(
      id: json['id']?.toString() ?? json['Id']?.toString(),
      name: json['name'] ?? json['Name'] ?? 'No Name',
      description: json['description'] ?? json['Description'] ?? 'No Description',
      latitude: (json['latitude'] ?? json['Latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] ?? json['Longitude'] as num?)?.toDouble() ?? 0.0,
      photoUrls: _parsePhotos(json['photos'] ?? json['Photos'] ?? json['imageUrls'] ?? json['ImageUrls'] ?? json['images'] ?? json['Images'] ?? json['photoUrls'] ?? json['photoUrl'] ?? json['ImageUrl'] ?? json['imageUrl'] ?? json['photo'] ?? json['PhotoUrl']),
      status: json['status']?.toString() ?? json['Status']?.toString() ?? 'pending',
      createdAt: json['createdAt'] != null || json['CreatedAt'] != null 
          ? DateTime.tryParse((json['createdAt'] ?? json['CreatedAt']).toString()) 
          : null,
      adminReply: json['adminReply']?.toString() ?? json['AdminReply']?.toString() ?? json['admin_reply']?.toString() ?? json['response']?.toString(),
    );
  }

  static List<String> _parsePhotos(dynamic imageField) {
    if (imageField == null) return [];
    if (imageField is List) {
      return imageField.map((e) => e.toString()).toList();
    } else if (imageField is String && imageField.trim().isNotEmpty) {
      if (imageField.contains(';')) {
        return imageField.split(';').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      }
      return [imageField];
    }
    return [];
  }

  @override
  List<Object?> get props => [id, name, description, latitude, longitude, photoUrls, status, createdAt, adminReply];
}
