import 'package:equatable/equatable.dart';

class ReportModel extends Equatable {
  final String? id;
  final String title;
  final String description;
  final double latitude;
  final double longitude;
  final List<String> photoUrls;
  final String? status;
  final DateTime? createdAt;
  final String? adminReply;

  const ReportModel({
    this.id,
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
    this.photoUrls = const [],
    this.status,
    this.createdAt,
    this.adminReply,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    double lat = 0.0;
    double lng = 0.0;
    
    final loc = json['location'] ?? json['Location'];
    if (loc != null && loc is String) {
      final parts = loc.split(',');
      if (parts.length >= 2) {
        lat = double.tryParse(parts[0]) ?? 0.0;
        lng = double.tryParse(parts[1]) ?? 0.0;
      }
    } else {
      lat = (json['latitude'] ?? json['Latitude'] as num?)?.toDouble() ?? 0.0;
      lng = (json['longitude'] ?? json['Longitude'] as num?)?.toDouble() ?? 0.0;
    }

    final statusVal = json['status']?.toString() ?? json['Status']?.toString() ?? 'pending';
    final dateVal = json['createdAt']?.toString() ?? json['CreatedAt']?.toString() ?? json['created_at']?.toString();

    return ReportModel(
      id: json['id']?.toString() ?? json['Id']?.toString(),
      title: json['title'] ?? json['Title'] ?? 'No Title',
      description: json['description'] ?? json['Description'] ?? 'No Description',
      latitude: lat,
      longitude: lng,
      photoUrls: _parsePhotos(json['photos'] ?? json['Photos'] ?? json['imageUrls'] ?? json['ImageUrls'] ?? json['images'] ?? json['Images'] ?? json['photoUrls'] ?? json['photoUrl'] ?? json['ImageUrl'] ?? json['imageUrl'] ?? json['photo']),
      status: statusVal,
      createdAt: dateVal != null ? DateTime.tryParse(dateVal) : null,
      adminReply: json['adminReply']?.toString() ?? json['AdminReply']?.toString() ?? json['admin_reply']?.toString() ?? json['response']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
    };
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
  List<Object?> get props => [id, title, description, latitude, longitude, photoUrls, status, createdAt, adminReply];
}
