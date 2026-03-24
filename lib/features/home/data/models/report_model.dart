import 'package:equatable/equatable.dart';

class ReportModel extends Equatable {
  final String? id;
  final String title;
  final String description;
  final double latitude;
  final double longitude;
  final String? photoUrl;
  final String? status;
  final DateTime? createdAt;
  final String? adminReply;

  const ReportModel({
    this.id,
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
    this.photoUrl,
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
      photoUrl: json['imageUrl'] ?? json['ImageUrl'] ?? json['photo'],
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

  @override
  List<Object?> get props => [id, title, description, latitude, longitude, photoUrl, status, createdAt, adminReply];
}
